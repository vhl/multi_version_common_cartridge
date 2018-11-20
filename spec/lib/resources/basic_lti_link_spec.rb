require 'spec_helper'
require 'multi_version_common_cartridge'

describe MultiVersionCommonCartridge::Resources::BasicLtiLink::BasicLtiLink do
  let(:lti_link) { described_class.new }

  describe '#initialize' do
    it 'initializes extensions to an empty array' do
      expect(lti_link.extensions).to be_empty
    end
  end

  describe '#vendor' do
    it 'returns a vendor' do
      expect(lti_link.vendor).to be_a(MultiVersionCommonCartridge::Resources::BasicLtiLink::Vendor)
    end
  end
end
