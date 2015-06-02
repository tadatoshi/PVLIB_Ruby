require 'spec_helper'
require 'bigdecimal'

describe DcToAcConversion do

  it 'should get AC power' do

    inverter = Inverter.new(name: 'SunPower Corp (Original Mfg - PV Powered): SPR-2500 240V [CEC 2006]', 
                            pac0: 2500, pdc0: 2630.0909, vdc0: 219.2317, ps0: 41.3618,
                            c0: -1.27e-05, c1: 6.67e-05, c2: 0.0017417, c3: 0.00061375, 
                            pnt: 3.9)

    dc_to_ac_conversion = DcToAcConversion.new(inverter)

    dc_input_voltage_1 = BigDecimal('178.2298') # for 200th row in PVSC40Tutorial_Master
    dc_input_power_1 = BigDecimal('19.0990') # for 200th row in PVSC40Tutorial_Master

    # Expected values are for 200th row in PVSC40Tutorial_Master
    expect(dc_to_ac_conversion.ac_power(dc_input_voltage_1, dc_input_power_1)).to eq(BigDecimal('-3.9000'))

    dc_input_voltage_2 = BigDecimal('181.9919') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    dc_input_power_2 = BigDecimal('1069.0') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)

    # Expected values are for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    expect(dc_to_ac_conversion.ac_power(dc_input_voltage_2, dc_input_power_2)).to be_within(0.1).of(BigDecimal('1016.3'))    

  end

end