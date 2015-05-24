require 'spec_helper'

describe PvModule do

  FIXTURES_DIRECTORY = File.expand_path('../../../fixtures', __FILE__)
  MODULE_DATA_FILENAME = "sandia_module_example.csv"

  it 'should generate model based on CSV data' do

    module_data_filename = File.join(FIXTURES_DIRECTORY, MODULE_DATA_FILENAME)
    
    sandia_pv_module = PvModule.new(module_data_filename)
    sandia_pv_module.load_data

    expect(sandia_pv_module.name).to eq("Sample Module")

  end

  it 'should create model based on CSV data' do

    module_data_filename = File.join(FIXTURES_DIRECTORY, MODULE_DATA_FILENAME)
    
    sandia_pv_module = PvModule.create(module_data_filename)

    expect(sandia_pv_module.name).to eq("Sample Module")

  end  

end
