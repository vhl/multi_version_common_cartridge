require 'spec_helper'
require 'multi_version_common_cartridge'

describe MultiVersionCommonCartridge::Writers::ManifestOrganizationWriter do
  let(:cartridge) { MultiVersionCommonCartridge::Cartridge.new }
  let(:manifest) { cartridge.manifest }
  let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
  let(:writers_factory) { MultiVersionCommonCartridge::Writers::Factory.new(cartridge, version) }
  let(:writer) { described_class.new(cartridge, writers_factory, version) }

  describe '#initialize' do
    context 'when a non supported version is specified,' do
      let(:version) { 'some random version' }

      it 'raises an error' do
        expect { writer }.to raise_error(
          ArgumentError,
          format(described_class::UNSUPPORTED_VERSION_MSG_TEMPLATE, version: version)
        )
      end
    end

    context 'when a supported version is specified,' do
      it 'does not raise an error' do
        described_class::SUPPORTED_VERSIONS.each do |version|
          factory = MultiVersionCommonCartridge::Writers::Factory.new(cartridge, version)
          expect { described_class.new(cartridge, factory, version) }.not_to raise_error
        end
      end
    end
  end

  describe '#finalize' do
    context 'when no identifier is set,' do
      it 'does no raise an error' do
        expect { writer.finalize }.not_to raise_error
      end
    end
  end

  context 'when finalizing for version 1.3.0,' do
    let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
    let(:identifier) { 'some identifier' }
    let(:item_count) { 2 }
    let(:items) { Array.new(item_count) { MultiVersionCommonCartridge::Item.new } }
    let(:item_writers) do
      Array.new(item_count) { instance_double(MultiVersionCommonCartridge::Writers::ItemWriter) }
    end
    let(:organization_item_elements) do
      Array.new(item_count) { CommonCartridge::Elements::Organizations::Item.new }
    end

    before do
      0.upto(item_count - 1) do |index|
        item = items[index]
        item_writer = item_writers[index]
        cartridge.add_item(item)
        allow(MultiVersionCommonCartridge::Writers::ItemWriter)
          .to receive(:new).with(item, writers_factory, version).and_return(item_writer)
        allow(item_writer).to receive(:finalize)
        allow(item_writer).to receive(:organization_item_element)
          .and_return(organization_item_elements[index])
      end
    end

    describe '#organization_element' do
      it 'returns an Organization element' do
        expect(writer.organization_element)
          .to be_a(CommonCartridge::Elements::Organizations::Organization)
      end

      it 'sets the organization structure' do
        writer.finalize
        expect(writer.organization_element.structure)
          .to eq(described_class::ORGANIZATION_STRUCTURE)
      end

      context 'when an identifier is set,' do
        it 'sets the organization identifier' do
          manifest.organization_identifier = identifier
          writer.finalize
          expect(writer.organization_element.root_item.identifier).to eq(identifier)
        end
      end

      context 'when no identifier is set,' do
        it 'sets the organization identifier with the default value' do
          writer.finalize
          expect(writer.organization_element.root_item.identifier)
            .to eq(described_class::DEFAULT_ROOT_ITEM_IDENTIFIER)
        end
      end

      it 'sets the organization root items' do
        writer.finalize
        writer.organization_element
        expect(writer.organization_element.root_item.items).to eq(organization_item_elements)
      end
    end
  end
end
