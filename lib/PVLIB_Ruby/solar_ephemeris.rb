require 'bigdecimal'

class SolarEphemeris
  include CalculationHelper

  def initialize(time, location, pressure: BigDecimal('101325'), temperature: BigDecimal('12'))
    @time = time
    @location = location
    @pressure = pressure
    @temperature = temperature
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
      
    end

    def declination

    end

    # LocAST in PVLIB_MatLab. Couldn't find what it stands for. 
    # Also for other variables names, couldn't find what they stand for. 
    # For hour_angle calculation
    def loc_ast

      dec_hours = BigDecimal(@time.hour.to_s) + BigDecimal(@time.min.to_s) / BigDecimal('60') + BigDecimal(@time.sec.to_s) / BigDecimal('3600')

      utc_offset_in_hours = BigDecimal(@time.utc_offset.to_s) / BigDecimal('3600')
      universal_date = BigDecimal(@time.yday.to_s) + ((dec_hours - utc_offset_in_hours) / BigDecimal('24')).floor
      # universal_date = @time.yday
      universal_hour = (dec_hours - utc_offset_in_hours).modulo(BigDecimal('24')) 



      # time = @time.getutc
      # universal_date = time.yday
      # universal_hour = time.hour

      year_starting_from_1900 = BigDecimal(@time.year.to_s) - BigDecimal('1900')
      year_begin = BigDecimal('365') * year_starting_from_1900 + ((year_starting_from_1900 - BigDecimal('1')) / BigDecimal('4')).floor - BigDecimal('0.5')
      ezero = year_begin + universal_date
      t = ezero / 36525

      gmst0 = BigDecimal('6') / BigDecimal('24') + BigDecimal('38') / BigDecimal('1440') + 
              (BigDecimal('45.836') + BigDecimal('8640184.542') * t + BigDecimal('0.0929') * t.power(2) ) / BigDecimal('86400')
      gmst0 = BigDecimal('360') * (gmst0 - gmst0.floor)
      gmsti = (gmst0 + BigDecimal('360') * (BigDecimal('1.0027379093') * universal_hour / BigDecimal('24'))).modulo(BigDecimal('360')) 

      (BigDecimal('360') + gmsti + @location.longitude).modulo(BigDecimal('360')) 
    end

end