require 'spec_helper'
require 'multi_version_common_cartridge'

describe MultiVersionCommonCartridge::Cartridge do
  let(:cartridge) { described_class.new }
  let(:item_1) { MultiVersionCommonCartridge::Item.new }
  let(:item_2) { MultiVersionCommonCartridge::Item.new }
  let(:item_1_child_1) { MultiVersionCommonCartridge::Item.new }
  let(:item_1_child_2) { MultiVersionCommonCartridge::Item.new }
  let(:item_1_child_1_grand_child_1) { MultiVersionCommonCartridge::Item.new }
  let(:resources) do
    Array.new(2) do
      MultiVersionCommonCartridge::Resources::BasicLtiLink::BasicLtiLink.new.tap do |lti|
        lti.vendor.code = 'Vhl Central'
        lti.vendor.name = 'Vista Higher Learning'
        lti.vendor.url = 'https://www.vhlcentral.com'
        lti.vendor.contact_email = 'contact@vhlcentral.com'
      end
    end
  end
  let(:resource_1) { resources[0] }
  let(:resource_2) { resources[1] }

  describe '#manifest' do
    it 'returns a cartridge manifest' do
      expect(cartridge.manifest).to be_a(MultiVersionCommonCartridge::Manifest)
    end
  end

  describe '#add_item' do
    it 'adds an item' do
      cartridge.add_item(item_1)
      cartridge.add_item(item_2)
      expect(cartridge.items).to eq([item_1, item_2])
    end
  end

  describe 'all_items' do
    before do
      item_1.add_item(item_1_child_1)
      item_1.add_item(item_1_child_2)
      item_1_child_1.add_item(item_1_child_1_grand_child_1)
      cartridge.add_item(item_1)
      cartridge.add_item(item_2)
    end

    it 'returns all items in the hierarchy' do
      expect(cartridge.all_items).to match_array(
        [item_1, item_2, item_1_child_1, item_1_child_2, item_1_child_1_grand_child_1]
      )
    end
  end

  describe 'all_resources' do
    before do
      item_1.add_item(item_1_child_1)
      item_1.add_item(item_1_child_2)
      item_1_child_1.add_item(item_1_child_1_grand_child_1)
      cartridge.add_item(item_1)
      cartridge.add_item(item_2)

      item_1_child_1_grand_child_1.resource = resource_1
      item_2.resource = resource_2
    end

    it 'returns all the items resources in the item hierarchy' do
      expect(cartridge.all_resources).to match_array(
        [resource_1, resource_2]
      )
    end
  end
end
