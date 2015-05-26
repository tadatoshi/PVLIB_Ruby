require 'spec_helper'
require 'bigdecimal'

describe PvPerformanceCharacterization do

  it 'should get 5 points on IV curve' do

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

    # Expected values are for 200th row in PVSC40Tutorial_Master
    expect(pv_performance_characterization.short_circuit_current).to eq(BigDecimal('0.1137'))
    expect(pv_performance_characterization.isc).to eq(BigDecimal('0.1137'))

    expect(pv_performance_characterization.maximum_power_point_current).to eq(BigDecimal('0.1072'))
    expect(pv_performance_characterization.imp).to eq(BigDecimal('0.1072'))   

    expect(pv_performance_characterization.open_circuit_voltage).to eq(BigDecimal('41.8039'))
    expect(pv_performance_characterization.voc).to eq(BigDecimal('41.8039'))  

    expect(pv_performance_characterization.maximum_power_point_voltage).to eq(BigDecimal('35.6460'))
    expect(pv_performance_characterization.vmp).to eq(BigDecimal('35.6460'))

    # Current at a voltage equal to one-half of the open-circuit voltage:
    expect(pv_performance_characterization.fourth_point_current).to eq(BigDecimal('0.1122'))
    expect(pv_performance_characterization.ix).to eq(BigDecimal('0.1122'))

    # Current at a voltage midway between Vmp and Voc:
    expect(pv_performance_characterization.fifth_point_current).to eq(BigDecimal('0.0846'))
    expect(pv_performance_characterization.ixx).to eq(BigDecimal('0.0846'))    

  end

end