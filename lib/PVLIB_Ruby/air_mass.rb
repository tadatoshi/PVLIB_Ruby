require 'bigdecimal'

# The default model for relative air mass is 'kastenyoung1989'. Different model is realized by subclass. 
# 'kastenyoung1989' model is based on:
# Fritz Kasten and Andrew Young. "Revised optical air mass tables and approximation formula". Applied Optics 28:47354738
class AirMass
  include CalculationHelper

  def initialize(sun_zenith, pressure)
    @sun_zenith = sun_zenith
    @pressure = pressure
  end

  # Relative air mass at sea level
  def relative_air_mass
    relative_air_mass = BigDecimal('1') / (Math.cos(degree_to_radian(@sun_zenith).to_f) + BigDecimal('0.50572') * ((BigDecimal('6.07995') + (BigDecimal('90') - @sun_zenith)).power(-1.6364)))
    relative_air_mass = BigDecimal('0') if relative_air_mass.nan?
    relative_air_mass
  end

  # Airmass for locations not at sea level (i.e. not at standard pressure)
  def absolute_air_mass
    relative_air_mass * @pressure / BigDecimal('101325')
  end

end