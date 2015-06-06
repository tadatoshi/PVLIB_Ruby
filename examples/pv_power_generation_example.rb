# NOTE: PVLIB_Ruby gem must be installed in local machine in order to run this code. 
#       Execute "rake install" to use the code in this gem. 
#       Or if you use the gem downloaded from RubyGems.org, you don't have to execute "rake install" and just do "gem install PVLIB_Ruby"

require 'pvlib_ruby'

require 'bigdecimal'

DATA_DIRECTORY = File.expand_path('../data', __FILE__)

# for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
sun_zenith = BigDecimal('45.7486')
pressure = BigDecimal('62963')
angle_of_incidence = BigDecimal('10.8703')
beam_irradiance = BigDecimal('619.9822')
ground_irradiance = BigDecimal('11.6927')
sky_diffuse_irradiance = BigDecimal('464.8004')

solar_irradiance_incident_on_module_surface = BigDecimal('1096.5')
reference_solar_irradiance = BigDecimal('1000')
wind_speed = BigDecimal('2.8786')
air_temperature = BigDecimal('20.7700')

estimated_cell_temperature = BigDecimal('47.7235')

sandia_module_data_filepath = File.join(DATA_DIRECTORY, 'sandia_module_example.csv')
sandia_pv_module = PvModule.create(sandia_module_data_filepath)

pv_temperature = PvTemperature.new(sandia_pv_module, solar_irradiance_incident_on_module_surface, reference_solar_irradiance, wind_speed, air_temperature)

puts "------------- PV temperature --------------"
puts "  Estimated Cell Temperature [ºC]: #{pv_temperature.cell_temperature.round(4).to_s('F')}" # Slight difference from 47.7235 for 360th row in PVSC40Tutorial_Master
puts "  Estimated Module Temperature [ºC]: #{pv_temperature.module_temperature.round(4).to_s('F')}" # Slight difference from 44.4341 for 360th row in PVSC40Tutorial_Master
puts "-------------------------------------------"
puts ""

estimated_cell_temperature = pv_temperature.cell_temperature

air_mass = AirMass.new(sun_zenith, pressure)

puts "---------------- Air Mass -----------------"
puts "  Absolute Air Mass: #{air_mass.absolute_air_mass.round(4).to_s('F')}"
puts "-------------------------------------------"
puts ""

absolute_air_mass = air_mass.absolute_air_mass

pv_performance_characterization = PvPerformanceCharacterization.new(sandia_pv_module, absolute_air_mass, angle_of_incidence, 
                                                                    beam_irradiance, ground_irradiance, sky_diffuse_irradiance, 
                                                                    estimated_cell_temperature)

puts "--- PV module IV curve characterization ---"
puts "  Short Circuit Current [A]: #{pv_performance_characterization.short_circuit_current.round(4).to_s('F')}"
puts "  Maximum Power Point Current [A]: #{pv_performance_characterization.maximum_power_point_current.round(4).to_s('F')}"
puts "  Open Circuit Voltage [V]: #{pv_performance_characterization.open_circuit_voltage.round(4).to_s('F')}"
puts "  Maximum Power Point Voltage [V]: #{pv_performance_characterization.maximum_power_point_voltage.round(4).to_s('F')}"
puts "  Fourth Point Current [A]: #{pv_performance_characterization.fourth_point_current.round(4).to_s('F')}"
puts "  Fifth Point Current [A]: #{pv_performance_characterization.fifth_point_current.round(4).to_s('F')}"
puts "-------------------------------------------"
puts ""

parallel_string = BigDecimal('1')
series_modules = BigDecimal('5')
array_current = pv_performance_characterization.maximum_power_point_current * parallel_string
array_voltage = pv_performance_characterization.maximum_power_point_voltage * series_modules
array_power = array_current * array_voltage

puts "------------- PV array output -------------"
puts "  Array current [A]: #{array_current.round(4).to_s('F')}" # Matches to 5.8741 for 360th row in PVSC40Tutorial_Master
puts "  Array voltage [V]: #{array_voltage.round(4).to_s('F')}" # Matches to 181.9919 for 360th row in PVSC40Tutorial_Master
puts "  Array power [W]: #{array_power.round(4).to_s('F')}" # Matches to 1069.0 (with rounding) for 360th row in PVSC40Tutorial_Master
puts "-------------------------------------------"
puts ""

sandia_inverter_data_filename = File.join(DATA_DIRECTORY, 'sandia_inverter_example.csv')
sandia_inverter = Inverter.create(sandia_inverter_data_filename)

dc_to_ac_conversion = DcToAcConversion.new(sandia_inverter)

puts "--- Inverter DC to AC conversion ---"
puts "  AC power [W]: #{dc_to_ac_conversion.ac_power(array_voltage, array_power).round(4).to_s('F')}" # Matches to 1016.3 (with rounding) for 360th row in PVSC40Tutorial_Master
puts "------------------------------------"
puts ""
