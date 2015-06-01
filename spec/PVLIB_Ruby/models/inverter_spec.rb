require 'spec_helper'

describe Inverter do

  INVERTER_DATA_FILENAME = "sandia_inverter_example.csv"

  it 'should create model based on CSV data' do

    inverter_data_filename = File.join(FIXTURES_DIRECTORY, INVERTER_DATA_FILENAME)
    
    sandia_inverter = Inverter.create(inverter_data_filename)

    expect(sandia_inverter.name).to eq('SunPower Corp (Original Mfg - PV Powered): SPR-2500 240V [CEC 2006]')

  end  

  it 'should create model by specifying parameters' do

    inverter = Inverter.new(name: 'Test Inverter')

    expect(inverter.name).to eq('Test Inverter')

  end

end