require 'spec_helper'
require 'bigdecimal'

describe SolarGeometry do

  it 'should calculate Angle of Incidence' do

    array_tilt = BigDecimal('35')
    array_azimuth = BigDecimal('180')    
    sun_zenith = BigDecimal('45.7486') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    sun_azimuth = BigDecimal('182.5229') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)

    solar_geometry = SolarGeometry.new(array_tilt, array_azimuth, sun_zenith, sun_azimuth)    

    # Expected values are for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    expect(solar_geometry.angle_of_incidence).to be_within(0.0001).of(BigDecimal('10.8703'))

  end



end