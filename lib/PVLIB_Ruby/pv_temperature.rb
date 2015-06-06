require 'bigdecimal'

# This class calculates cell and module temperatures using Sandia PV Array Performance Model, which is based on:
# King, D. et al, 2004, "Sandia Photovoltaic Array Performance Model", SAND Report 3535, Sandia National Laboratories, Albuquerque, NM
class PvTemperature
  include CalculationHelper

  def initialize(pv_module, solar_irradiance_incident_on_module_surface, reference_solar_irradiance, wind_speed, air_temperature)
    @pv_module = pv_module
    @solar_irradiance_incident_on_module_surface = solar_irradiance_incident_on_module_surface
    @reference_solar_irradiance = reference_solar_irradiance
    @wind_speed = wind_speed
    @air_temperature = air_temperature
  end

  def cell_temperature
    module_temperature + 
    (@solar_irradiance_incident_on_module_surface / @reference_solar_irradiance) * @pv_module.cell_module_back_surface_temperature_difference
  end

  def module_temperature
    back_surface_module_temperature = @solar_irradiance_incident_on_module_surface * bigdecimal_exp(@pv_module.temperature_upper_limit_coefficient + @pv_module.wind_speed_decrease_rate_coefficient * @wind_speed) + 
                                      @air_temperature
  end

end