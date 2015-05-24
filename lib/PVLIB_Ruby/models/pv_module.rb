class PvModule < ActiveCsv

  attr_accessor :name, :vintage, :material, :area, :alphaisc, :alphaimp, :isc0, :imp0, :voc0, :vmp0 
  attr_accessor :betavoc, :betavmp, :mbetavoc, :mbetavmp, :ns, :np, :delt, :fd, :n, :ix0, :ixx0, :a_wind, :b_wind
  attr_accessor :c, :a, :b

end