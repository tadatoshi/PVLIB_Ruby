require 'spec_helper'

describe Location do

  LOCATION_DATA_FILENAME = 'sandia_location_example.csv'

  it 'should create location based on CSV data' do

    inverter_data_filename = File.join(FIXTURES_DIRECTORY, LOCATION_DATA_FILENAME)
    
    sandia_location = Location.create(inverter_data_filename)

    expect(sandia_location.latitude).to eq('35.05')
    expect(sandia_location.longitude).to eq('-106.54')
    expect(sandia_location.altitude).to eq('1660')

  end  

  it 'should create location by specifying parameters' do

    inverter = Location.new(latitude: '45')

    expect(inverter.latitude).to eq('45')

  end

end