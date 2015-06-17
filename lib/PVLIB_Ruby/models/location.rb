# This is a model in model-view-controller design pattern. 
# In this case, it is expending ActiveCsv, i.e. it is analogous to ActiveRecord. Hence, it's a placeholder for data from CSV file. 
class Location < ActiveCsv

  attr_accessor :latitude, :longitude, :altitude

end