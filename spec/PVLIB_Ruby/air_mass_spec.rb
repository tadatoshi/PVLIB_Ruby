require 'spec_helper'
require 'bigdecimal'

describe AirMass do

  it "should calculate relative and absolute air mass" do

    sun_zenith = BigDecimal('45.7486') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    pressure = BigDecimal('62963') # [Pa]: for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)

    air_mass = AirMass.new(sun_zenith, pressure)

    # Expected values are for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    expect(air_mass.relative_air_mass).to be_within(0.0001).of(BigDecimal('1.4314'))
    expect(air_mass.absolute_air_mass).to be_within(0.0001).of(BigDecimal('0.8894'))

  end

end