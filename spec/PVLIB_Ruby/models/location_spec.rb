require 'spec_helper'
require 'bigdecimal'

describe Location do

  LOCATION_DATA_FILENAME = 'sandia_location_example.csv'

  it 'should create location based on CSV data' do

    inverter_data_filename = File.join(FIXTURES_DIRECTORY, LOCATION_DATA_FILENAME)
    
    sandia_location = Location.create(inverter_data_filename)

    # In this class, the name of attribute from CSV file and the attr_reader method name are same. 
    # Hence, reader method for the same name is added that converts the value to BigDecimal. 
    expect(sandia_location.latitude).to eq(BigDecimal('35.05'))
    expect(sandia_location.longitude).to eq(BigDecimal('-106.54'))
    expect(sandia_location.altitude).to eq(BigDecimal('1660'))

  end  

  it 'should create location by specifying parameters' do

    inverter = Location.new(latitude: '45')

    expect(inverter.latitude).to eq(BigDecimal('45'))

  end

end