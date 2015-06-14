require 'spec_helper'
require 'bigdecimal'

describe SolarEphemeris do

  xit 'should calculate without pressure and temperature' do

    utc_offset = '-07:00'
    time = Time.new(2008, 10, 20, 11, 58, 12, utc_offset) # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    latitude = BigDecimal('35.0500')
    longitude = BigDecimal('-106.5400')
    altitude = BigDecimal('1660')
    location = Location.new(latitude, longitude, altitude)

    solar_ephemeris = SolarEphemeris.new(time, location)

    expect(solar_ephemeris.sun_azimuth).to eq(BigDecimal('182.5229'))
    expect(solar_ephemeris.sun_elevation).to eq(BigDecimal('44.2415'))
    expect(solar_ephemeris.apparent_sun_elevation).to eq(BigDecimal('44.2579'))
    expect(solar_ephemeris.solar_time).to eq(BigDecimal('12.1226'))

  end

  xit 'should calculate with pressure and without temperature' do

    utc_offset = '-07:00'
    time = Time.new(2008, 10, 20, 11, 58, 12, utc_offset) # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    latitude = BigDecimal('35.0500')
    longitude = BigDecimal('-106.5400')
    altitude = BigDecimal('1660')
    location = Location.new(latitude, longitude, altitude)
    pressure = BigDecimal('62993') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)

    solar_ephemeris = SolarEphemeris.new(time, location, pressure: pressure)

    expect(solar_ephemeris.sun_azimuth).to eq(BigDecimal('182.5229'))
    expect(solar_ephemeris.sun_elevation).to eq(BigDecimal('44.2415'))
    expect(solar_ephemeris.apparent_sun_elevation).to eq(BigDecimal('44.2517'))
    expect(solar_ephemeris.solar_time).to eq(BigDecimal('12.1226'))

  end

  xit 'should calculate without pressure and with temperature' do

    utc_offset = '-07:00'
    time = Time.new(2008, 10, 20, 11, 58, 12, utc_offset) # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    latitude = BigDecimal('35.0500')
    longitude = BigDecimal('-106.5400')
    altitude = BigDecimal('1660')
    location = Location.new(latitude, longitude, altitude)
    temperature = BigDecimal('20.7700') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)

    solar_ephemeris = SolarEphemeris.new(time, location, temperature: temperature)

    expect(solar_ephemeris.sun_azimuth).to eq(BigDecimal('182.5229'))
    expect(solar_ephemeris.sun_elevation).to eq(BigDecimal('44.2415'))
    expect(solar_ephemeris.apparent_sun_elevation).to eq(BigDecimal('44.2574'))
    expect(solar_ephemeris.solar_time).to eq(BigDecimal('12.1226'))    

  end  

  xit 'should calculate with pressure and temperature' do

    utc_offset = '-07:00'
    time = Time.new(2008, 10, 20, 11, 58, 12, utc_offset) # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    latitude = BigDecimal('35.0500')
    longitude = BigDecimal('-106.5400')
    altitude = BigDecimal('1660')
    location = Location.new(latitude, longitude, altitude)
    pressure = BigDecimal('62993') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    temperature = BigDecimal('20.7700') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)

    solar_ephemeris = SolarEphemeris.new(time, location, pressure: pressure, temperature: temperature)

    expect(solar_ephemeris.sun_azimuth).to eq(BigDecimal('182.5229'))
    expect(solar_ephemeris.sun_elevation).to eq(BigDecimal('44.2415'))
    expect(solar_ephemeris.apparent_sun_elevation).to eq(BigDecimal('44.2514'))
    expect(solar_ephemeris.solar_time).to eq(BigDecimal('12.1226'))

  end

  context 'supporting methods' do

    context 'hour angle' do

      xit 'should calculate hour_angle' do

        utc_offset = '-07:00'
        time = Time.new(2008, 10, 20, 11, 58, 12, utc_offset) # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
        latitude = BigDecimal('35.0500')
        longitude = BigDecimal('-106.5400')
        altitude = BigDecimal('1660')
        location = Location.new(latitude, longitude, altitude)
        pressure = BigDecimal('62993') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
        temperature = BigDecimal('20.7700') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)

        solar_ephemeris = SolarEphemeris.new(time, location, pressure: pressure, temperature: temperature)

        expect(solar_ephemeris.send(:hour_angle)).to eq(BigDecimal('361.8390'))

      end

      it 'should calculate loc_ast' do

        utc_offset = '-07:00'
        time = Time.new(2008, 10, 20, 11, 58, 12, utc_offset) # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
        latitude = BigDecimal('35.0500')
        longitude = BigDecimal('-106.5400')
        altitude = BigDecimal('1660')
        location = Location.new(latitude, longitude, altitude)
        pressure = BigDecimal('62993') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
        temperature = BigDecimal('20.7700') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)

        solar_ephemeris = SolarEphemeris.new(time, location, pressure: pressure, temperature: temperature)

        expect(solar_ephemeris.send(:loc_ast)).to be_within(0.0001).of(BigDecimal('207.6128'))        

      end

    end

    xit 'should calculate declination' do

      utc_offset = '-07:00'
      time = Time.new(2008, 10, 20, 11, 58, 12, utc_offset) # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      latitude = BigDecimal('35.0500')
      longitude = BigDecimal('-106.5400')
      altitude = BigDecimal('1660')
      location = Location.new(latitude, longitude, altitude)
      pressure = BigDecimal('62993') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      temperature = BigDecimal('20.7700') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)

      solar_ephemeris = SolarEphemeris.new(time, location, pressure: pressure, temperature: temperature)

      expect(solar_ephemeris.send(:declination)).to eq(BigDecimal('-10.6754'))

    end

  end

end