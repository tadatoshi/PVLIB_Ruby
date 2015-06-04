require 'pvlib_ruby'

require 'bigdecimal'

DATA_DIRECTORY = File.expand_path('../data', __FILE__)

# for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
absolute_air_mass = BigDecimal('0.8894')
angle_of_incidence = BigDecimal('10.8703')
beam_irradiance = BigDecimal('619.9822')
ground_irradiance = BigDecimal('11.6927')
sky_diffuse_irradiance = BigDecimal('464.8004')
estimated_cell_temperature = BigDecimal('47.7235')

sandia_module_data_filepath = File.join(DATA_DIRECTORY, 'sandia_module_example.csv')
sandia_pv_module = PvModule.create(sandia_module_data_filepath)

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

parallel_string = BigDecimal('1')
series_modules = BigDecimal('5')
array_current = pv_performance_characterization.maximum_power_point_current * parallel_string
array_voltage = pv_performance_characterization.maximum_power_point_voltage * series_modules
array_power = array_current * array_voltage

puts "--- PV array output ---"
puts "  Array current [A]: #{array_current.round(4).to_s('F')}" # Matches to 5.8741 for 360th row in PVSC40Tutorial_Master
puts "  Array voltage [V]: #{array_voltage.round(4).to_s('F')}" # Matches to 181.9919 for 360th row in PVSC40Tutorial_Master
puts "  Array power [W]: #{array_power.round(4).to_s('F')}" # Matches to 1069.0 (with rounding) for 360th row in PVSC40Tutorial_Master
puts "-----------------------"

sandia_inverter_data_filename = File.join(DATA_DIRECTORY, 'sandia_inverter_example.csv')
sandia_inverter = Inverter.create(sandia_inverter_data_filename)

dc_to_ac_conversion = DcToAcConversion.new(sandia_inverter)

puts "--- Inverter DC to AC conversion ---"
puts "  AC power [W]: #{dc_to_ac_conversion.ac_power(array_voltage, array_power).round(4).to_s('F')}" # Matches to 1016.3 (with rounding) for 360th row in PVSC40Tutorial_Master
puts "------------------------------------"
