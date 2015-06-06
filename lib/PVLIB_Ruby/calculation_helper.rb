module CalculationHelper

  def degree_to_radian(degree)
    degree * BigDecimal(Math::PI.to_s) / BigDecimal('180')
  end

  def radian_to_degree(radian)
    radian * BigDecimal('180') / BigDecimal(Math::PI.to_s)
  end

  def bigdecimal_exp(bigdecimal_value)
    BigDecimal(Math.exp(bigdecimal_value.to_f).to_s)
  end

end