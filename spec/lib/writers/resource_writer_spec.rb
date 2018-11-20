require 'spec_helper'
require 'multi_version_common_cartridge'

describe MultiVersionCommonCartridge::Writers::ResourceWriter do
  let(:resource) { MultiVersionCommonCartridge::Resources::Resource.new }
  let(:resource_writer) { described_class.new(resource, version) }
  let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
  let(:identifier) { 'some identifier' }

  describe '#initialize' do
    context 'when a non supported version is specified,' do
      let(:version) { 'some random version' }

      it 'raises an error' do
        expect { resource_writer }.to raise_error(
          ArgumentError,
          format(described_class::UNSUPPORTED_VERSION_MSG_TEMPLATE, version: version)
        )
      end
    end

    context 'when a supported version is specified,' do
      it 'does not raise an error' do
        described_class::SUPPORTED_VERSIONS.each do |version|
          expect { described_class.new(resource, version) }.not_to raise_error
        end
      end
    end
  end

  describe '#finalize' do
    context 'when no identifier is set,' do
      it 'creates a random identifier' do
        resource_writer.finalize
        expect(resource.identifier).not_to be_empty
      end
    end

    context 'when an identifier is set,' do
      it 'does not change the identifier' do
        resource.identifier = identifier
        resource_writer.finalize
        expect(resource.identifier).to eq(identifier)
      end
    end
  end

  context 'when finalizing for version 1.3.0,' do
    let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
    let(:resource_element) { resource_writer.resource_element }

    before do
      resource.identifier = identifier
      resource_writer.finalize
    end

    describe '#resource_element' do
      class CustomResource < described_class
        def type
          'custom type'
        end

        def files
          ['file_1', 'file_2']
        end
      end

      let(:resource_writer) { CustomResource.new(resource, version) }
      let(:resource_file_1) { instance_double(CommonCartridge::Elements::Resources::File) }
      let(:resource_file_2) { instance_double(CommonCartridge::Elements::Resources::File) }

      before do
        allow(CommonCartridge::Elements::Resources::File).to receive(:new)
          .with(href: 'file_1').and_return(resource_file_1)
        allow(CommonCartridge::Elements::Resources::File).to receive(:new)
          .with(href: 'file_2').and_return(resource_file_2)
      end

      it 'returns a resource element' do
        expect(resource_element).to be_a(CommonCartridge::Elements::Resources::Resource)
      end

      it 'sets the resource element identifier' do
        expect(resource_element.identifier).to eq(identifier)
      end

      it 'sets the resource element type' do
        expect(resource_element.type).to eq('custom type')
      end

      it 'sets the resource element files' do
        expect(resource_element.files).to eq([resource_file_1, resource_file_2])
      end
    end
  end
end
