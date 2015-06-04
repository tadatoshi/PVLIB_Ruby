module CalculationHelper

  def degree_to_radian(degree)
    degree * BigDecimal(Math::PI.to_s) / BigDecimal('180')
  end

  def radian_to_degree(radian)
    radian * BigDecimal('180') / BigDecimal(Math::PI.to_s)
  end

end