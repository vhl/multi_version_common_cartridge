require 'spec_helper'
require 'multi_version_common_cartridge'

describe MultiVersionCommonCartridge::Writers::ManifestResourcesWriter do
  let(:cartridge) { MultiVersionCommonCartridge::Cartridge.new }
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
    it 'does no raise an error' do
      expect { writer.finalize }.not_to raise_error
    end
  end

  context 'when finalizing for version 1.3.0,' do
    let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
    let(:identifier) { 'some identifier' }
    let(:resources) do
      Array.new(3) { MultiVersionCommonCartridge::Resources::BasicLtiLink::BasicLtiLink.new }
    end
    let(:resource_writers) do
      resources.map { instance_double(MultiVersionCommonCartridge::Writers::BasicLtiLinkWriter) }
    end
    let(:resource_elements) do
      resources.map { CommonCartridge::Elements::Resources::Resource.new }
    end

    before do
      allow(cartridge).to receive(:all_resources).and_return(resources)
      resources.each_with_index do |resource, index|
        resource_writer = resource_writers[index]
        resource_element = resource_elements[index]

        allow(resource_writer).to receive(:finalize)
        allow(resource_writer).to receive(:resource_element).and_return(resource_element)
        allow(MultiVersionCommonCartridge::Writers::ResourceWriter)
          .to receive(:new).with(resource, version).and_return(resource_writer)
      end
    end

    describe '#root_resource_element' do
      it 'returns a RootResource element' do
        expect(writer.root_resource_element)
          .to be_a(CommonCartridge::Elements::Resources::RootResource)
      end

      it 'sets the organization root items' do
        writer.finalize
        expect(writer.root_resource_element.resources).to eq(resource_elements)
      end
    end
  end
end
