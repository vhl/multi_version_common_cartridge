require 'spec_helper'
require 'multi_version_common_cartridge'

describe MultiVersionCommonCartridge::Writers::CartridgeWriter do
  let(:cartridge) { MultiVersionCommonCartridge::Cartridge.new }
  let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
  let(:writer) { described_class.new(cartridge, version) }

  it 'does not raise an error' do
    cartridge.manifest.set_title('my program')
    cartridge.manifest.description = 'some description'
    cartridge.manifest.identifier = 'some identifier'
    writer.finalize
  end
end

