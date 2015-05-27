class PvPerformanceCharacterization

  REFERECE_SOLAR_IRRADIANCE = BigDecimal('1000') # E0 [W/m^2]
  REFERECE_CELL_TEMPERATURE = BigDecimal('25')   # T0 [ºC]

  def initialize(pv_module, absolute_air_mass, angle_of_incidence, beam_irradiance, ground_irradiance, sky_diffuse_irradiance, estimated_cell_temperature)
    @pv_module = pv_module
    @effective_solar_irradiance = empirical_effective_solar_irradiance(absolute_air_mass, angle_of_incidence, beam_irradiance, ground_irradiance, sky_diffuse_irradiance)
    @estimated_cell_temperature = estimated_cell_temperature
  end

  def short_circuit_current
    @pv_module.short_circuit_current_0 * @effective_solar_irradiance * (1 + @pv_module.normalized_temperature_coefficient_for_short_circuit_current * (@estimated_cell_temperature - REFERECE_CELL_TEMPERATURE))
  end

  alias :isc :short_circuit_current

  private
    # Ee
    def empirical_effective_solar_irradiance(absolute_air_mass, angle_of_incidence, beam_irradiance, ground_irradiance, sky_diffuse_irradiance)
      diffuse_irradiance = ground_irradiance + sky_diffuse_irradiance

      empirical_solar_spectral_influence_on_short_circuit_current(absolute_air_mass) * 
      ((beam_irradiance * empirical_opitical_influence_on_short_circuit_current(angle_of_incidence) + @pv_module.diffuse_irradiance_factor * diffuse_irradiance)/REFERECE_SOLAR_IRRADIANCE)
    end

    # f1(AMa)
    def empirical_solar_spectral_influence_on_short_circuit_current(absolute_air_mass)
      @pv_module.air_mass_variation_polynomial_coefficients[4] +
      @pv_module.air_mass_variation_polynomial_coefficients[3] * absolute_air_mass + 
      @pv_module.air_mass_variation_polynomial_coefficients[2] * absolute_air_mass.power(2) +
      @pv_module.air_mass_variation_polynomial_coefficients[1] * absolute_air_mass.power(3) +
      @pv_module.air_mass_variation_polynomial_coefficients[0] * absolute_air_mass.power(4)
    end

    # f2(AOI)
    def empirical_opitical_influence_on_short_circuit_current(angle_of_incidence)
      @pv_module.angle_of_incidence_polynominal_coefficients[5] + 
      @pv_module.angle_of_incidence_polynominal_coefficients[4] * angle_of_incidence + 
      @pv_module.angle_of_incidence_polynominal_coefficients[3] * angle_of_incidence.power(2) + 
      @pv_module.angle_of_incidence_polynominal_coefficients[2] * angle_of_incidence.power(3) + 
      @pv_module.angle_of_incidence_polynominal_coefficients[1] * angle_of_incidence.power(4) + 
      @pv_module.angle_of_incidence_polynominal_coefficients[0] * angle_of_incidence.power(5)
    end

end