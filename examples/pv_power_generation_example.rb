# NOTE: PVLIB_Ruby gem must be installed in local machine in order to run this code. 
#       Execute "rake install" to use the code in this gem. 
#       Or if you use the gem downloaded from RubyGems.org, you don't have to execute "rake install" and just do "gem install PVLIB_Ruby"

require 'pvlib_ruby'

require 'bigdecimal'

DATA_DIRECTORY = File.expand_path('../data', __FILE__)

# for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
direct_normal_irradiance = BigDecimal('631.3100')
global_horizontal_irradiance = BigDecimal('862.0619')
diffuse_horizontal_irradiance = BigDecimal('405.3100')
day_of_year = BigDecimal('294')
utc_offset = '-07:00'
# TODO: Get time from year and day_of_year:
time = Time.new(2008, 10, 20, 11, 58, 12, utc_offset)
albedo = BigDecimal('0.1500')
array_tilt = BigDecimal('35')
array_azimuth = BigDecimal('180')   

sun_zenith = BigDecimal('45.7486')
sun_azimuth = BigDecimal('182.5229')



latitude = BigDecimal('35.0500')
longitude = BigDecimal('-106.5400')
altitude = BigDecimal('1660')
location = Location.new(latitude, longitude, altitude)

pressure = BigDecimal('62963')
reference_solar_irradiance = BigDecimal('1000')
wind_speed = BigDecimal('2.8786')
air_temperature = BigDecimal('20.7700')



solar_ephemeris = SolarEphemeris.new(time, location, pressure: pressure, temperature: air_temperature)

sun_azimuth = solar_ephemeris.sun_azimuth
apparent_sun_elevation = solar_ephemeris.apparent_sun_elevation

puts "------------- Solar Ephemeris -------------"
puts "  Sun Azimuth [º]: #{sun_azimuth.round(4).to_s('F')}" # TODO: Doesn't Match to 182.5229 for 360th row in PVSC40Tutorial_Master
puts "  Apparent Sun Elevation [º]: #{sun_zenith.round(4).to_s('F')}" # for 360th row in PVSC40Tutorial_Master
puts "-------------------------------------------"
puts ""

sun_azimuth = BigDecimal('90') - apparent_sun_elevation

plain_of_array_irradiance = PlainOfArrayIrradiance.new(direct_normal_irradiance, global_horizontal_irradiance, diffuse_horizontal_irradiance, day_of_year, albedo, array_tilt, array_azimuth, sun_zenith, sun_azimuth)    

angle_of_incidence = plain_of_array_irradiance.angle_of_incidence

beam_irradiance = plain_of_array_irradiance.beam_irradiance
ground_diffuse_irradiance = plain_of_array_irradiance.ground_diffuse_irradiance
sky_diffuse_irradiance = plain_of_array_irradiance.sky_diffuse_irradiance

puts "----- Plain Of Array (POA) Irradiance -----"
puts "  Angle of Incidence [º]: #{angle_of_incidence.round(4).to_s('F')}" # Matches to 10.8703 for 360th row in PVSC40Tutorial_Master
puts ""
puts "  Beam Irradiance [W/m^2]: #{beam_irradiance.round(4).to_s('F')}" # Matches to 619.9822 for 360th row in PVSC40Tutorial_Master
puts "  Ground Diffuse Irradiance [W/m^2]: #{ground_diffuse_irradiance.round(4).to_s('F')}" # Matches to 11.6927 for 360th row in PVSC40Tutorial_Master
puts "  Sky Diffuse Irradiance [W/m^2]: #{sky_diffuse_irradiance.round(4).to_s('F')}" # Matches to 464.8004 for 360th row in PVSC40Tutorial_Master
puts "-------------------------------------------"
puts ""

solar_irradiance_incident_on_module_surface = beam_irradiance + ground_diffuse_irradiance + sky_diffuse_irradiance

sandia_module_data_filepath = File.join(DATA_DIRECTORY, 'sandia_module_example.csv')
sandia_pv_module = PvModule.create(sandia_module_data_filepath)

pv_temperature = PvTemperature.new(sandia_pv_module, solar_irradiance_incident_on_module_surface, reference_solar_irradiance, wind_speed, air_temperature)

puts "------------- PV temperature --------------"
puts "  Estimated Cell Temperature [ºC]: #{pv_temperature.cell_temperature.round(4).to_s('F')}" # Slight difference from 47.7235 for 360th row in PVSC40Tutorial_Master
puts "  Estimated Module Temperature [ºC]: #{pv_temperature.module_temperature.round(4).to_s('F')}" # Matches to 44.4341 for 360th row in PVSC40Tutorial_Master
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
                                                                    beam_irradiance, ground_diffuse_irradiance, sky_diffuse_irradiance, 
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
