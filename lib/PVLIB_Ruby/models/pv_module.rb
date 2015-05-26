require 'bigdecimal'

class PvModule < ActiveCsv

  attr_accessor :name, :vintage, :material, :area, :alphaisc, :alphaimp, :isc0, :imp0, :voc0, :vmp0 
  attr_accessor :betavoc, :betavmp, :mbetavoc, :mbetavmp, :ns, :np, :delt, :fd, :n, :ix0, :ixx0, :a_wind, :b_wind
  attr_accessor :c, :a, :b

  def short_circuit_current_0
    BigDecimal(self.isc0.to_s)
  end

  def air_mass_variation_polynomial_coefficients
    self.a.map {|coefficient| BigDecimal(coefficient.to_s)}
  end

  def angle_of_incidence_polynominal_coefficients
    self.b.map {|coefficient| BigDecimal(coefficient.to_s)}
  end

  def diffuse_irradiance_factor
    BigDecimal(self.fd)
  end

  def normalized_temperature_coefficient_for_short_circuit_current
    BigDecimal(self.alphaisc.to_s)
  end

end