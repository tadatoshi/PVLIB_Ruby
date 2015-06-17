# This is a model in model-view-controller design pattern. 
# In this case, it is expending ActiveCsv, i.e. it is analogous to ActiveRecord. Hence, it's a placeholder for data from CSV file. 
class Location < ActiveCsv

  attr_writer :latitude, :longitude, :altitude

  def latitude
    BigDecimal(@latitude.to_s)
  end

  def longitude
    BigDecimal(@longitude.to_s)
  end

  def altitude
    BigDecimal(@altitude.to_s)
  end

end