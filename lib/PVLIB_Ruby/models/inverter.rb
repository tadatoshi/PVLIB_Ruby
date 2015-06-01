class Inverter < ActiveCsv
  
  attr_accessor :name, :vac, :pac0, :pdc0, :vdc0, :ps0, :c0, :c1, :c2, :c3 
  attr_accessor :pnt, :vdcmax, :idcmax, :mpptlow, :mppthi, :librarytype, :libraryname

end