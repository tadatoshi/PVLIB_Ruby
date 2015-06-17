require 'spec_helper'

describe PvModule do

  MODULE_DATA_FILENAME = 'sandia_module_example.csv'

  it 'should create model based on CSV data' do

    module_data_filename = File.join(FIXTURES_DIRECTORY, MODULE_DATA_FILENAME)
    
    sandia_pv_module = PvModule.create(module_data_filename)

    expect(sandia_pv_module.name).to eq('Sample Module')
    expect(sandia_pv_module.a).to eq(['-0.0001223', '0.002416', '-0.01912', '0.07365', '0.9259'])
    expect(sandia_pv_module.b).to eq(['-2.99e-09', '5.35e-07', '-3.4e-05', '0.000862', '-0.00699', '1'])

  end

  it 'should create model by specifying parameters' do

    pv_module = PvModule.new(name: 'Test Module')

    expect(pv_module.name).to eq('Test Module')

  end

end
