require 'bigdecimal'

# This class uses Sandia's Grid-Connected PV Inverter model, which is based on:
# SAND2007-5036, "Performance Model for Grid-Connected Photovoltaic Inverters by D. King, S. Gonzalez, G. Galbraith, W. Boyson
# Since this paper was not available any more, we referred to https://pvpmc.sandia.gov/modeling-steps/dc-to-ac-conversion/sandia-inverter-model/
# Other inverter models are realized by subclasses. 
class DcToAcConversion

  def initialize(inverter)  
    @inverter = inverter
  end

  def ac_power(dc_input_voltage, dc_input_power)
    # A = Pdc0 * ( 1 + C1 * (Vdc - Vdc0) )
    dc_power_adjustment_parameter = @inverter.dc_power_for_maximum_ac_power_rating * (1 + @inverter.coefficient_for_dc_power_for_maximum_ac_power_rating * (dc_input_voltage - @inverter.dc_power_level_for_maximum_ac_power_rating))

    # B = Ps0 * ( 1 + C2 * (Vdc - Vdc0) )
    starting_dc_power_adjustment_parameter = @inverter.starting_dc_power * (1 + @inverter.coefficient_for_starting_dc_power * (dc_input_voltage - @inverter.dc_power_level_for_maximum_ac_power_rating))

    # C = C0 * ( 1 + C3 * (Vdc - Vdc0) )
    coefficient_adjustment_parameter = @inverter.power_adjustment_coefficient * (1 + @inverter.coefficient_for_power_adjustment_coefficient * (dc_input_voltage - @inverter.dc_power_level_for_maximum_ac_power_rating))

    ac_power = (@inverter.maximum_ac_power_rating / (dc_power_adjustment_parameter - starting_dc_power_adjustment_parameter) - coefficient_adjustment_parameter * (dc_power_adjustment_parameter - starting_dc_power_adjustment_parameter)) * (dc_input_power - starting_dc_power_adjustment_parameter) + 
    coefficient_adjustment_parameter * (dc_input_power - starting_dc_power_adjustment_parameter).power(2)

    adjust_ac_power(ac_power)
  end

  private
    def adjust_ac_power(ac_power)
      if ac_power > @inverter.maximum_ac_power_rating # Inverter clipping at maximum rated AC Power
        maximum_ac_power_rating
      elsif ac_power < @inverter.starting_dc_power # Inverter night tare losses
        -(@inverter.night_tare_loss.abs)
      else
        ac_power
      end
    end 

end