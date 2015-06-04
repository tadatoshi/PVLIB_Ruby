require 'bigdecimal'

# This is a model in model-view-controller design pattern. 
# In this case, it is expending ActiveCsv, i.e. it is analogous to ActiveRecord. Hence, it's a placeholder for data from CSV file. 
class Inverter < ActiveCsv
  
  attr_accessor :name, :vac, :pac0, :pdc0, :vdc0, :ps0, :c0, :c1, :c2, :c3 
  attr_accessor :pnt, :vdcmax, :idcmax, :mpptlow, :mppthi, :librarytype, :libraryname

  def maximum_ac_power_rating
    BigDecimal(self.pac0.to_s)
  end

  def dc_power_for_maximum_ac_power_rating
    BigDecimal(self.pdc0.to_s)
  end

  def coefficient_for_dc_power_for_maximum_ac_power_rating
    BigDecimal(self.c1.to_s)
  end

  def dc_power_level_for_maximum_ac_power_rating
    BigDecimal(self.vdc0.to_s)
  end

  def starting_dc_power
    BigDecimal(self.ps0.to_s)
  end

  def coefficient_for_starting_dc_power
    BigDecimal(self.c2.to_s)
  end

  def power_adjustment_coefficient
    BigDecimal(self.c0.to_s)
  end

  def coefficient_for_power_adjustment_coefficient
    BigDecimal(self.c3.to_s)
  end

  def night_tare_loss
    BigDecimal(self.pnt.to_s)
  end

end