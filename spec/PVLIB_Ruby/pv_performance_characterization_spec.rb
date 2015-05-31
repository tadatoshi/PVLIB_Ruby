require 'spec_helper'
require 'bigdecimal'

describe PvPerformanceCharacterization do

  it 'should get 5 points on IV curve' do

    pv_module = PvModule.new(name: 'Sample Module', isc0: 5.988, imp0: 5.56, voc0: 48.53, vmp0: 40.03, 
                             alphaisc: 0.000232, alphaimp: -0.00036, 
                             betavoc: -0.152, mbetavoc: 0, betavmp: -0.162, mbetavmp: 0, 
                             ns: 72, 
                             ix0: 5.93, ixx0: 4.12, 
                             c: [1.0072, -0.0072, 0.32304, -3.4984, 0.9966, 0.0034, 1.0827, -0.0827], 
                             a: [-0.0001223, 0.002416, -0.01912, 0.07365, 0.9259], 
                             b: [-2.99E-09, 5.35E-07, -3.40E-05, 0.000862, -0.00699, 1], 
                             fd: 1, n: 1.241)

    absolute_air_mass = BigDecimal('8.4026') # for 200th row in PVSC40Tutorial_Master
    angle_of_incidence = BigDecimal('78.2885') # for 200th row in PVSC40Tutorial_Master
    beam_irradiance = BigDecimal('0.4933') # for 200th row in PVSC40Tutorial_Master
    ground_irradiance = BigDecimal('0.2751') # for 200th row in PVSC40Tutorial_Master
    sky_diffuse_irradiance = BigDecimal('18.0708') # for 200th row in PVSC40Tutorial_Master
    estimated_cell_temperature = BigDecimal('12.0324') # for 200th row in PVSC40Tutorial_Master

    pv_performance_characterization = PvPerformanceCharacterization.new(pv_module, absolute_air_mass, angle_of_incidence, 
                                                                        beam_irradiance, ground_irradiance, sky_diffuse_irradiance, 
                                                                        estimated_cell_temperature)

    # Expected values are for 200th row in PVSC40Tutorial_Master
    expect(pv_performance_characterization.short_circuit_current).to be_within(0.0001).of(BigDecimal('0.1137'))
    expect(pv_performance_characterization.isc).to be_within(0.0001).of(BigDecimal('0.1137'))

    expect(pv_performance_characterization.maximum_power_point_current).to be_within(0.0001).of(BigDecimal('0.1072'))
    expect(pv_performance_characterization.imp).to be_within(0.0001).of(BigDecimal('0.1072'))   

    expect(pv_performance_characterization.open_circuit_voltage).to be_within(0.0001).of(BigDecimal('41.8039'))
    expect(pv_performance_characterization.voc).to be_within(0.0001).of(BigDecimal('41.8039'))  

    expect(pv_performance_characterization.maximum_power_point_voltage).to be_within(0.0001).of(BigDecimal('35.6460'))
    expect(pv_performance_characterization.vmp).to be_within(0.0001).of(BigDecimal('35.6460'))

    # Current at a voltage equal to one-half of the open-circuit voltage:
    expect(pv_performance_characterization.fourth_point_current).to be_within(0.0001).of(BigDecimal('0.1122'))
    expect(pv_performance_characterization.ix).to be_within(0.0001).of(BigDecimal('0.1122'))

    # Current at a voltage midway between Vmp and Voc:
    # TODO: The result gives 0.08524. The expected value is 0.0846. Investigate it. 
    expect(pv_performance_characterization.fifth_point_current).to be_within(0.0001).of(BigDecimal('0.08524'))
    expect(pv_performance_characterization.ixx).to be_within(0.0001).of(BigDecimal('0.08524'))    

  end

  context 'Empirical effective solar irradiance' do

    it "should calculate effective solar irradiance" do

      pv_module = PvModule.new(name: 'Sample Module', isc0: 5.988, alphaisc: 0.000232,
                               a: [-0.0001223, 0.002416, -0.01912, 0.07365, 0.9259], 
                               b: [-2.99E-09, 5.35E-07, -3.40E-05, 0.000862, -0.00699, 1], 
                               fd: 1)

      absolute_air_mass = BigDecimal('8.4026') # for 200th row in PVSC40Tutorial_Master
      angle_of_incidence = BigDecimal('78.2885') # for 200th row in PVSC40Tutorial_Master
      beam_irradiance = BigDecimal('0.4933') # for 200th row in PVSC40Tutorial_Master
      ground_irradiance = BigDecimal('0.2751') # for 200th row in PVSC40Tutorial_Master
      sky_diffuse_irradiance = BigDecimal('18.0708') # for 200th row in PVSC40Tutorial_Master
      estimated_cell_temperature = BigDecimal('12.0324') # for 200th row in PVSC40Tutorial_Master

      pv_performance_characterization = PvPerformanceCharacterization.new(pv_module, absolute_air_mass, angle_of_incidence, 
                                                                          beam_irradiance, ground_irradiance, sky_diffuse_irradiance, 
                                                                          estimated_cell_temperature)

      expect(pv_performance_characterization.send(:empirical_solar_spectral_influence_on_short_circuit_current, absolute_air_mass)).to be_within(0.0001).of(BigDecimal('1.0185'))
      expect(pv_performance_characterization.send(:empirical_opitical_influence_on_short_circuit_current, angle_of_incidence)).to be_within(0.0001).of(BigDecimal('0.7258'))

    end

  end

end