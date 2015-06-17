require 'spec_helper'
require 'bigdecimal'

describe PlainOfArrayIrradiance do

  it 'should calculate Plain of Array Beam Irradiance' do

    direct_normal_irradiance = BigDecimal('631.3100') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    global_horizontal_irradiance = BigDecimal('862.0619') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    diffuse_horizontal_irradiance = BigDecimal('405.3100') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    day_of_year = BigDecimal('294') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    albedo = BigDecimal('0.1500')
    array_tilt = BigDecimal('35')
    array_azimuth = BigDecimal('180')    
    sun_zenith = BigDecimal('45.7486') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    sun_azimuth = BigDecimal('182.5229') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)

    plain_of_array_irradiance = PlainOfArrayIrradiance.new(direct_normal_irradiance, global_horizontal_irradiance, diffuse_horizontal_irradiance, day_of_year, albedo, array_tilt, array_azimuth, sun_zenith, sun_azimuth)    

    # Expected values are for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    expect(plain_of_array_irradiance.beam_irradiance).to be_within(0.0001).of(BigDecimal('619.9822'))

  end

  it 'should calculate Plain of Array Ground Diffuse Irradiance' do

    direct_normal_irradiance = BigDecimal('631.3100') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    global_horizontal_irradiance = BigDecimal('862.0619') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    diffuse_horizontal_irradiance = BigDecimal('405.3100') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    day_of_year = BigDecimal('294') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    albedo = BigDecimal('0.1500')
    array_tilt = BigDecimal('35')
    array_azimuth = BigDecimal('180')   
    sun_zenith = BigDecimal('45.7486') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    sun_azimuth = BigDecimal('182.5229') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)

    plain_of_array_irradiance = PlainOfArrayIrradiance.new(direct_normal_irradiance, global_horizontal_irradiance, diffuse_horizontal_irradiance, day_of_year, albedo, array_tilt, array_azimuth, sun_zenith, sun_azimuth)    

    # Expected values are for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
    expect(plain_of_array_irradiance.ground_diffuse_irradiance).to be_within(0.0001).of(BigDecimal('11.6927'))

  end  

  context 'Sky Diffuse Irradiance' do

    it 'should calculate various parameters for sky diffuse irradiance calculation' do

      direct_normal_irradiance = BigDecimal('631.3100') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      global_horizontal_irradiance = BigDecimal('862.0619') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      diffuse_horizontal_irradiance = BigDecimal('405.3100') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      day_of_year = BigDecimal('294') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      albedo = BigDecimal('0.1500')
      array_tilt = BigDecimal('35')
      array_azimuth = BigDecimal('180') 
      sun_zenith = BigDecimal('45.7486') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      sun_azimuth = BigDecimal('182.5229') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)

      plain_of_array_irradiance = PlainOfArrayIrradiance.new(direct_normal_irradiance, global_horizontal_irradiance, diffuse_horizontal_irradiance, day_of_year, albedo, array_tilt, array_azimuth, sun_zenith, sun_azimuth)    
            
      # Expected values are for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      expect(plain_of_array_irradiance.send(:hourly_beam_radiation_on_tilted_surface)).to be_within(0.0001).of(BigDecimal('0.9821'))      
      expect(plain_of_array_irradiance.send(:geometric_factor)).to be_within(0.0001).of(BigDecimal('1.4073'))      
      expect(plain_of_array_irradiance.send(:anisotropy_index)).to be_within(0.0001).of(BigDecimal('0.4573')) 
      # Note: Got '0.4405331446 1121826348 2E3'. Only minimal difference.      
      expect(plain_of_array_irradiance.send(:horizontal_beam_irradiance)).to be_within(0.0002).of(BigDecimal('440.5330'))
      expect(plain_of_array_irradiance.send(:horizontal_brighting_correction_factor)).to be_within(0.0001).of(BigDecimal('0.7149'))
      expect(plain_of_array_irradiance.send(:anisotropic_correction_factor)).to be_within(0.0001).of(BigDecimal('1.0194'))

    end

    it 'should calculate extraterrestrial irradiance' do

      direct_normal_irradiance = BigDecimal('631.3100') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      global_horizontal_irradiance = BigDecimal('862.0619') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      diffuse_horizontal_irradiance = BigDecimal('405.3100') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      day_of_year = BigDecimal('294') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      albedo = BigDecimal('0.1500')
      array_tilt = BigDecimal('35')
      array_azimuth = BigDecimal('180') 
      sun_zenith = BigDecimal('45.7486') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      sun_azimuth = BigDecimal('182.5229') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)

      plain_of_array_irradiance = PlainOfArrayIrradiance.new(direct_normal_irradiance, global_horizontal_irradiance, diffuse_horizontal_irradiance, day_of_year, albedo, array_tilt, array_azimuth, sun_zenith, sun_azimuth)    

      expect(plain_of_array_irradiance.extraterrestrial_irradiance).to be_within(0.1).of(BigDecimal('1380.7'))            

    end

    it 'should calculate Plain of Array Sky Diffuse Irradiance' do

      direct_normal_irradiance = BigDecimal('631.3100') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      global_horizontal_irradiance = BigDecimal('862.0619') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      diffuse_horizontal_irradiance = BigDecimal('405.3100') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      day_of_year = BigDecimal('294') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      albedo = BigDecimal('0.1500')
      array_tilt = BigDecimal('35')
      array_azimuth = BigDecimal('180') 
      sun_zenith = BigDecimal('45.7486') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      sun_azimuth = BigDecimal('182.5229') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      
      plain_of_array_irradiance = PlainOfArrayIrradiance.new(direct_normal_irradiance, global_horizontal_irradiance, diffuse_horizontal_irradiance, day_of_year, albedo, array_tilt, array_azimuth, sun_zenith, sun_azimuth)    

      # Expected values are for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      expect(plain_of_array_irradiance.sky_diffuse_irradiance).to be_within(0.0001).of(BigDecimal('464.8004'))

    end

  end 

  context 'Angle of Incidence' do

    it 'should calculate Angle of Incidence' do

      direct_normal_irradiance = BigDecimal('631.3100') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      global_horizontal_irradiance = BigDecimal('862.0619') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      diffuse_horizontal_irradiance = BigDecimal('405.3100') # [W/m^2] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      day_of_year = BigDecimal('294') # for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      albedo = BigDecimal('0.1500')
      array_tilt = BigDecimal('35')
      array_azimuth = BigDecimal('180') 
      sun_zenith = BigDecimal('45.7486') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      sun_azimuth = BigDecimal('182.5229') # [º] for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      
      plain_of_array_irradiance = PlainOfArrayIrradiance.new(direct_normal_irradiance, global_horizontal_irradiance, diffuse_horizontal_irradiance, day_of_year, albedo, array_tilt, array_azimuth, sun_zenith, sun_azimuth)          

      # Expected values are for 360th row in PVSC40Tutorial_Master (360/30 = 12, i.e. noon, note: measurement is every two minutes)
      expect(plain_of_array_irradiance.angle_of_incidence).to be_within(0.0001).of(BigDecimal('10.8703'))

    end

  end

end