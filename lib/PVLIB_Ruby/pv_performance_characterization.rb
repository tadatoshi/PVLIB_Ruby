require 'bigdecimal'
require 'bigdecimal/math'

# This class uses Sandia PV Array Performance Model, which is based on:
# King, D. et al, 2004, "Sandia Photovoltaic Array Performance Model", SAND Report 3535, Sandia National Laboratories, Albuquerque, NM
# Other models are realized by subclasses. 
class PvPerformanceCharacterization

  REFERECE_SOLAR_IRRADIANCE = BigDecimal('1000') # E0 [W/m^2]
  REFERECE_CELL_TEMPERATURE = BigDecimal('25')   # T0 [ºC]
  BOLTZMANN_CONSTANT = BigDecimal('1.38066E-23') # k [J/K]
  ELEMENTARY_CHARGE = BigDecimal('1.60218E-19') # q [C(coulomb)] 

  def initialize(pv_module, absolute_air_mass, angle_of_incidence, beam_irradiance, ground_irradiance, sky_diffuse_irradiance, estimated_cell_temperature)
    @pv_module = pv_module
    @effective_solar_irradiance = empirical_effective_solar_irradiance(absolute_air_mass, angle_of_incidence, beam_irradiance, ground_irradiance, sky_diffuse_irradiance)
    @estimated_cell_temperature = estimated_cell_temperature
  end

  # Isc
  def short_circuit_current
    @pv_module.short_circuit_current_0 * @effective_solar_irradiance * (1 + @pv_module.normalized_temperature_coefficient_for_short_circuit_current * (@estimated_cell_temperature - REFERECE_CELL_TEMPERATURE))
  end

  alias :isc :short_circuit_current

  # Imp
  def maximum_power_point_current
    @pv_module.maximum_power_point_current_0 * (@pv_module.performance_coefficients[0] * @effective_solar_irradiance + @pv_module.performance_coefficients[1] * @effective_solar_irradiance.power(2)) * 
    (1 + @pv_module.normalized_temperature_coefficient_for_maximum_power_point_current * (@estimated_cell_temperature - REFERECE_CELL_TEMPERATURE))
  end

  alias :imp :maximum_power_point_current

  # Voc
  def open_circuit_voltage
    @pv_module.open_circuit_voltage_0 + @pv_module.number_of_cells_in_series * thermal_voltage_per_cell * BigMath.log(@effective_solar_irradiance, 4) +
    temperature_coefficient_for_open_circuit_voltage * (@estimated_cell_temperature - REFERECE_CELL_TEMPERATURE)
  end

  alias :voc :open_circuit_voltage

  # Vmp
  def maximum_power_point_voltage
    @pv_module.maximum_power_point_voltage_0 + @pv_module.performance_coefficients[2] * @pv_module.number_of_cells_in_series * thermal_voltage_per_cell * BigMath.log(@effective_solar_irradiance, 4) + 
    @pv_module.performance_coefficients[3] * @pv_module.number_of_cells_in_series * (thermal_voltage_per_cell * BigMath.log(@effective_solar_irradiance, 4)).power(2) + 
    temperature_coefficient_for_maximum_power_point_voltage * (@estimated_cell_temperature - REFERECE_CELL_TEMPERATURE)
  end

  alias :vmp :maximum_power_point_voltage

  # Ix
  def fourth_point_current
    @pv_module.fourth_point_current_0 * (@pv_module.performance_coefficients[4] * @effective_solar_irradiance + @pv_module.performance_coefficients[5] * @effective_solar_irradiance.power(2)) * 
    (1 + @pv_module.normalized_temperature_coefficient_for_short_circuit_current * (@estimated_cell_temperature - REFERECE_CELL_TEMPERATURE))
  end

  alias :ix :fourth_point_current

  # Ixx
  def fifth_point_current
    @pv_module.fifth_point_current_0 * (@pv_module.performance_coefficients[6] * @effective_solar_irradiance + @pv_module.performance_coefficients[7] * @effective_solar_irradiance.power(2)) * 
    (1 + @pv_module.normalized_temperature_coefficient_for_maximum_power_point_current * (@estimated_cell_temperature - REFERECE_CELL_TEMPERATURE))
  end

  alias :ixx :fifth_point_current

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

    # delta(Tc)
    def thermal_voltage_per_cell
      @pv_module.diode_factor * BOLTZMANN_CONSTANT * (@estimated_cell_temperature + BigDecimal('273.15')) / ELEMENTARY_CHARGE
    end

    # BetaVoc
    def temperature_coefficient_for_open_circuit_voltage
      @pv_module.temperature_coefficient_for_open_circuit_voltage + @pv_module.irradiance_dependent_temperature_coefficient_for_open_circuit_voltage * (1-@effective_solar_irradiance)
    end

    # BetaVmp
    def temperature_coefficient_for_maximum_power_point_voltage
      @pv_module.temperature_coefficient_for_maximum_power_point_voltage + @pv_module.irradiance_dependent_temperature_coefficient_for_maximum_power_point_voltage * (1-@effective_solar_irradiance)
    end

end