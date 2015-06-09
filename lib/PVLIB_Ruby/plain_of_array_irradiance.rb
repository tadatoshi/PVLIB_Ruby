require 'bigdecimal'

# For Sky Diffuse Irradiance, "Reindl's 1990 model" is used. 
# Other models are realized by subclasses. 
#
# References
#   [3] Reindl, D.T., Beckmann, W.A., Duffie, J.A., 1990b. Evaluation of hourly
#   tilted surface radiation models. Solar Energy 45 (1), 917.
# 
# TODO: Consider to pass necessary parameters to the respective methods instead of passing all of them to the constructor. 
#       Haven't decided which way would be better. 
class PlainOfArrayIrradiance
  include CalculationHelper

  SMALL_VALUE_FOR_SKY_DIFFUSE_IRRADIANCE = BigDecimal('0.000001') # In order to make the calculated value consistent with the one by PVLIB_MatLab

  def initialize(direct_normal_irradiance, global_horizontal_irradiance, diffuse_horizontal_irradiance, extraterrestrial_irradiance, albedo, angle_of_incidence, surface_tilt, surface_azimuth, sun_zenith, sun_azimuth)
    @direct_normal_irradiance = direct_normal_irradiance           # DNI
    @global_horizontal_irradiance = global_horizontal_irradiance   # GHI
    @diffuse_horizontal_irradiance = diffuse_horizontal_irradiance # DHI
    @extraterrestrial_irradiance = extraterrestrial_irradiance
    @albedo = albedo
    @angle_of_incidence = angle_of_incidence
    @surface_tilt = surface_tilt
    @surface_azimuth = surface_azimuth
    @sun_zenith = sun_zenith
    @sun_azimuth = sun_azimuth
  end

  def beam_irradiance
    @direct_normal_irradiance * bigdecimal_cos(degree_to_radian(@angle_of_incidence))
  end

  def ground_diffuse_irradiance
    @global_horizontal_irradiance * @albedo * (1 - bigdecimal_cos(degree_to_radian(@surface_tilt))) * BigDecimal('0.5')
  end

  # Based on the equation (5) of [3]
  def sky_diffuse_irradiance
    @diffuse_horizontal_irradiance * (anisotropy_index * geometric_factor + 
                                      (1 - anisotropy_index) * ((BigDecimal('1') + bigdecimal_cos(degree_to_radian(@surface_tilt))) / BigDecimal('2')) * anisotropic_correction_factor)
  end

  private
    # Rb 
    # Reference:
    #   3. Titled Surface Models
    #   in [3]
    def geometric_factor
      hourly_beam_radiation_on_tilted_surface / hourly_beam_radiation_on_horizontal_surface
    end

    # I[b,T]
    def hourly_beam_radiation_on_tilted_surface
      hourly_bean_radiation = bigdecimal_cos(degree_to_radian(@surface_tilt)) * bigdecimal_cos(degree_to_radian(@sun_zenith)) + 
                              bigdecimal_sin(degree_to_radian(@surface_tilt)) * bigdecimal_sin(degree_to_radian(@sun_zenith)) * bigdecimal_cos(degree_to_radian(@sun_azimuth - @surface_azimuth))
      [hourly_bean_radiation, BigDecimal('0')].max
    end

    # Ib
    def hourly_beam_radiation_on_horizontal_surface
      [bigdecimal_cos(degree_to_radian(@sun_zenith)), BigDecimal('0.01745')].max
    end

    # AI
    #   "defines the portion of the diffuse radiation to be treated as circumsolar with the remaining portion considered isotropic"[3]
    def anisotropy_index
      @direct_normal_irradiance / @extraterrestrial_irradiance
    end

    def anisotropic_correction_factor
      sin_cube_of_half_surface_tilt = (bigdecimal_sin(degree_to_radian(@surface_tilt/BigDecimal('2')))).power(3)
      BigDecimal('1') + horizontal_brighting_correction_factor * sin_cube_of_half_surface_tilt
    end

    # f: Horizontal brighting correction factor
    #   page 13 of [3]
    def horizontal_brighting_correction_factor
      adjusted_global_horizontal_irradiance = @global_horizontal_irradiance < SMALL_VALUE_FOR_SKY_DIFFUSE_IRRADIANCE ? SMALL_VALUE_FOR_SKY_DIFFUSE_IRRADIANCE : @global_horizontal_irradiance
      # In PVLIB_MatLab as well as PVLIB_Python, there is a following adjustment. 
      # However, all the negative numbers are already converted to SMALL_VALUE_FOR_SKY_DIFFUSE_IRRADIANCE in the above statement, 
      # the following statement doesn't do anything. 
      # I'm just writing it to remind that it is there in PVLIB_MatLab and PVLIB_Python. 
      # adjusted_global_horizontal_irradiance = @global_horizontal_irradiance < BigDecimal('0') ? BigDecimal('0') : @global_horizontal_irradiance
      bigdecimal_sqrt(horizontal_beam_irradiance / adjusted_global_horizontal_irradiance)
    end

    # HB
    def horizontal_beam_irradiance
      calculated_horizontal_beam_irradiance = @direct_normal_irradiance * bigdecimal_cos(degree_to_radian(@sun_zenith))
      calculated_horizontal_beam_irradiance < BigDecimal('0') ? BigDecimal('0') : calculated_horizontal_beam_irradiance
    end    

end