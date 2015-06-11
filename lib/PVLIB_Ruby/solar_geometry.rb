require 'bigdecimal'

class SolarGeometry
  include CalculationHelper

  def initialize(surface_tilt, surface_azimuth, sun_zenith, sun_azimuth)
    @surface_tilt = surface_tilt
    @surface_azimuth = surface_azimuth
    @sun_zenith = sun_zenith
    @sun_azimuth = sun_azimuth
  end

  def angle_of_incidence
    cosine_of_angle_of_incidence = bigdecimal_cos(degree_to_radian(@sun_zenith)) * bigdecimal_cos(degree_to_radian(@surface_tilt)) + 
                                bigdecimal_sin(degree_to_radian(@surface_tilt)) * bigdecimal_sin(degree_to_radian(@sun_zenith)) * bigdecimal_cos(degree_to_radian(@sun_azimuth - @surface_azimuth))

    if cosine_of_angle_of_incidence > BigDecimal('1')
      cosine_of_angle_of_incidence = BigDecimal('1')
    elsif cosine_of_angle_of_incidence < BigDecimal('-1')
      cosine_of_angle_of_incidence = BigDecimal('-1')
    end

    radian_to_degree(big_decimal_acos(cosine_of_angle_of_incidence))
  end

end