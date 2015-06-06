require 'bigdecimal'

# This is a model in model-view-controller design pattern. 
# In this case, it is expending ActiveCsv, i.e. it is analogous to ActiveRecord. Hence, it's a placeholder for data from CSV file. 
class PvModule < ActiveCsv

  attr_accessor :name, :vintage, :material, :area, :alphaisc, :alphaimp, :isc0, :imp0, :voc0, :vmp0 
  attr_accessor :betavoc, :betavmp, :mbetavoc, :mbetavmp, :ns, :np, :delt, :fd, :n, :ix0, :ixx0, :a_wind, :b_wind
  attr_accessor :c, :a, :b

  def short_circuit_current_0
    BigDecimal(self.isc0.to_s)
  end

  def air_mass_variation_polynomial_coefficients
    convert_coefficients_to_bigdecimal(self.a)
  end

  def angle_of_incidence_polynominal_coefficients
    convert_coefficients_to_bigdecimal(self.b)
  end

  def diffuse_irradiance_factor
    BigDecimal(self.fd)
  end

  def normalized_temperature_coefficient_for_short_circuit_current
    BigDecimal(self.alphaisc.to_s)
  end

  def maximum_power_point_current_0
    BigDecimal(self.imp0.to_s)
  end

  def performance_coefficients
    convert_coefficients_to_bigdecimal(self.c)
  end

  def normalized_temperature_coefficient_for_maximum_power_point_current
    BigDecimal(self.alphaimp.to_s)
  end

  def open_circuit_voltage_0
    BigDecimal(self.voc0.to_s)
  end

  def number_of_cells_in_series
    BigDecimal(self.ns.to_s)
  end

  def diode_factor
    BigDecimal(self.n.to_s)
  end

  def temperature_coefficient_for_open_circuit_voltage
    BigDecimal(self.betavoc.to_s)
  end

  def irradiance_dependent_temperature_coefficient_for_open_circuit_voltage
    BigDecimal(self.mbetavoc.to_s)
  end

  def maximum_power_point_voltage_0
    BigDecimal(self.vmp0.to_s)
  end

  def temperature_coefficient_for_maximum_power_point_voltage
    BigDecimal(self.betavmp.to_s)
  end

  def irradiance_dependent_temperature_coefficient_for_maximum_power_point_voltage
    BigDecimal(self.mbetavmp.to_s)
  end

  def fourth_point_current_0
    BigDecimal(self.ix0.to_s)
  end

  def fifth_point_current_0
    BigDecimal(self.ixx0.to_s)
  end

  def temperature_upper_limit_coefficient
    BigDecimal(self.a_wind.to_s)
  end

  def wind_speed_decrease_rate_coefficient
    BigDecimal(self.b_wind.to_s)
  end

  def cell_module_back_surface_temperature_difference
    BigDecimal(self.delt.to_s)
  end

  private
    def convert_coefficients_to_bigdecimal(coefficients)
      coefficients.map {|coefficient| BigDecimal(coefficient.to_s)}.compact
    end

end