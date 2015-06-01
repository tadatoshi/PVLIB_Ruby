require 'spec_helper'

describe PvModule do

  MODULE_DATA_FILENAME = "sandia_module_example.csv"

  it 'should create model based on CSV data' do

    module_data_filename = File.join(FIXTURES_DIRECTORY, MODULE_DATA_FILENAME)
    
    sandia_pv_module = PvModule.create(module_data_filename)

    expect(sandia_pv_module.name).to eq('Sample Module')

  end  

  it 'should create model by specifying parameters' do

    pv_module = PvModule.new(name: 'Test Module')

    expect(pv_module.name).to eq('Test Module')

  end

end
