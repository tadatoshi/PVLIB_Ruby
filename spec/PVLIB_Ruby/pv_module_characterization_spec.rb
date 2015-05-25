require 'spec_helper'

describe PvModuleCharacterization do

  xit 'should get 5 points on IV curve' do

    pv_module = PvModule.new(name: 'Sample Module')

    pv_module_characterization = PvModuleCharacterization.new(pv_module)

    expect(pv_module_characterization.short_circuit_current).to eq(BigDecimal('0.1137'))
    expect(pv_module_characterization.isc).to eq(BigDecimal('0.1137'))

  end

end