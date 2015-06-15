require 'bigdecimal'

class SolarEphemeris
  include CalculationHelper

  def initialize(time, location, pressure: BigDecimal('101325'), temperature: BigDecimal('12'))
    @time = time
    @location = location
    @pressure = pressure
    @temperature = temperature

    utc_offset_in_hours = BigDecimal(@time.utc_offset.to_s) / BigDecimal('3600')
    dec_hours = BigDecimal(@time.hour.to_s) + BigDecimal(@time.min.to_s) / BigDecimal('60') + BigDecimal(@time.sec.to_s) / BigDecimal('3600')
    @universal_date = BigDecimal(@time.yday.to_s) + ((dec_hours - utc_offset_in_hours) / BigDecimal('24')).floor
    @universal_hour = (dec_hours - utc_offset_in_hours).modulo(BigDecimal('24')) 
  end

  def sun_azimuth
    radian_to_degree(big_decimal_atan2(BigDecimal('-1') * big_decimal_sin(degree_to_radian(hour_angle)), 
                                       big_decimal_cos(degree_to_radian(@location.latitude)) * bigdecimal_tan(degree_to_radian(declination)) - big_decimal_sin(degree_to_radian(@location.latitude)) * big_decimal_cos(degree_to_radian(hour_angle))))
  end

  def sun_elevation

  end

  def apparent_sun_elevation

  end

  def solar_time

  end

  private
    def hour_angle
      loc_ast - rt_ascen
    end

    def declination

    end

    # For hour_angle calculation
    # LocAST in PVLIB_MatLab. Couldn't find what it stands for. 
    # Also for other variables names, couldn't find what they stand for. 
    def loc_ast
      t = e_zero / 36525

      gmst0 = BigDecimal('6') / BigDecimal('24') + BigDecimal('38') / BigDecimal('1440') + 
              (BigDecimal('45.836') + BigDecimal('8640184.542') * t + BigDecimal('0.0929') * t.power(2) ) / BigDecimal('86400')
      gmst0 = BigDecimal('360') * (gmst0 - gmst0.floor)
      gmsti = (gmst0 + BigDecimal('360') * (BigDecimal('1.0027379093') * @universal_hour / BigDecimal('24'))).modulo(BigDecimal('360')) 

      (BigDecimal('360') + gmsti + @location.longitude).modulo(BigDecimal('360')) 
    end

    # For hour_angle calculation
    # RtAscen in PVLIB_MatLab. Couldn't find what it stands for. 
    # Also for other variables names, couldn't find what they stand for. 
    def rt_ascen
      radian_to_degree(big_decimal_atan2(bigdecimal_cos(degree_to_radian(obliquity)) * bigdecimal_sin(degree_to_radian(ec_lon)), bigdecimal_cos(degree_to_radian(ec_lon))))
    end

    def obliquity
      BigDecimal('23.452294') - BigDecimal('0.0130125') * t1 - BigDecimal('0.00000164') * t1.power(2) + BigDecimal('0.000000503') * t1.power(3)
    end

    def ec_lon
      (ml_perigee + true_anom).modulo(BigDecimal('360')) - abber
    end

    def ml_perigee
      BigDecimal('281.22083') + BigDecimal('0.0000470684') * epoch_date + BigDecimal('0.000453') * t1.power(2) + BigDecimal('0.000003') * t1.power(3)
    end

    def true_anom
      # Cannot find a proper name for these values:
      temp1 = ((BigDecimal('1') + eccen) / (BigDecimal('1') - eccen)).power(0.5) * bigdecimal_tan(degree_to_radian(eccen_anom / BigDecimal('2')))
      temp2 = radian_to_degree(big_decimal_atan2(temp1, BigDecimal('1')))
      BigDecimal('2') * temp2.modulo(BigDecimal('360'))
    end

    def abber
      BigDecimal('20') / BigDecimal('3600')
    end

    def eccen
      BigDecimal('0.01675104') - BigDecimal('0.0000418') * t1 - BigDecimal('0.000000126') * t1.power(2)
    end

    def eccen_anom
      mean_anom = (BigDecimal('358.47583') + BigDecimal('0.985600267') * epoch_date - BigDecimal('0.00015') * t1.power(2) - BigDecimal('0.000003') * t1.power(3)).modulo(BigDecimal('360'))

      eccen_anom = mean_anom
      e = BigDecimal('0')
      while (mean_anom - e).abs > BigDecimal('0.0001')
        e = eccen_anom
        eccen_anom = mean_anom + radian_to_degree(eccen) * bigdecimal_sin(degree_to_radian(e))
      end
      eccen_anom
    end

    def t1
      epoch_date / BigDecimal('36525')
    end

    def epoch_date
      e_zero + @universal_hour / BigDecimal('24')
    end 

    def e_zero
      year_starting_from_1900 = BigDecimal(@time.year.to_s) - BigDecimal('1900')
      year_begin = BigDecimal('365') * year_starting_from_1900 + ((year_starting_from_1900 - BigDecimal('1')) / BigDecimal('4')).floor - BigDecimal('0.5')
      year_begin + @universal_date
    end

end