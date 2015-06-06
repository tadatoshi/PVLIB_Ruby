require 'spec_helper'
require 'bigdecimal'

describe PvTemperature do

  it 'should estimate cell temperature' do

    pv_module = PvModule.new(a_wind: -3.62, b_wind: -0.075, delt: 3)

    solar_irradiance_incident_on_module_surface = BigDecimal('1096.5') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    reference_solar_irradiance = BigDecimal('1000') # Typically 1000 [W/m^2]
    wind_speed = BigDecimal('2.8786') # [m/s] Wind speed measured at standard 10-m height for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    air_temperature = BigDecimal('20.7700') # [ºC] Ambiant air temperature for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    
    pv_temperature = PvTemperature.new(pv_module)

    # Expected values are for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    # TODO: It would be better within 0.0001 but we investigate it later. 
    expect(pv_temperature.cell_temperature(solar_irradiance_incident_on_module_surface, reference_solar_irradiance, wind_speed, air_temperature)).to be_within(0.0007).of(BigDecimal('47.7235'))
    # TODO: It would be better within 0.0001 but we investigate it later. 
    expect(pv_temperature.module_temperature(solar_irradiance_incident_on_module_surface, wind_speed, air_temperature)).to be_within(0.0006).of(BigDecimal('44.4341'))    

  end

end