require 'spec_helper'
require 'multi_version_common_cartridge'

describe MultiVersionCommonCartridge::Writers::BasicLtiExtensionWriter do
  let(:platform) { 'canvas.instructure.com' }
  let(:extension_key) { 'oauth_compliant' }
  let(:extension_value) { true }
  let(:extension) do
    MultiVersionCommonCartridge::Resources::BasicLtiLink::Extension.new(platform).tap do |extension|
      extension.properties[extension_key] = extension_value
    end
  end
  let(:extension_writer) { described_class.new(extension, version) }
  let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }

  describe '#initialize' do
    context 'when a non supported version is specified,' do
      let(:version) { 'some random version' }

      it 'raises an error' do
        expect { extension_writer }.to raise_error(
          ArgumentError,
          format(described_class::UNSUPPORTED_VERSION_MSG_TEMPLATE, version: version)
        )
      end
    end

    context 'when a supported version is specified,' do
      it 'does not raise an error' do
        described_class::SUPPORTED_VERSIONS.each do |version|
          expect { described_class.new(extension, version) }.not_to raise_error
        end
      end
    end
  end

  describe '#finalize' do
    it 'does not raise an error' do
      expect { extension_writer.finalize }.not_to raise_error
    end
  end

  context 'when finalizing for version 1.3.0,' do
    let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
    let(:extension_element) { extension_writer.extension_element }
    let(:extension_property_element) do
      CommonCartridge::Elements::Resources::BasicLtiLink::ExtensionProperty.new(
        name: extension_key, value: extension_value
      )
    end

    before do
      allow(CommonCartridge::Elements::Resources::BasicLtiLink::ExtensionProperty)
        .to receive(:new).with(name: extension_key, value: extension_value)
        .and_return(extension_property_element)
      extension_writer.finalize
    end

    describe '#extension_element' do
      it 'returns a basic lti link extension element' do
        expect(extension_element).to be_a(CommonCartridge::Elements::Resources::BasicLtiLink::Extension)
      end

      it 'sets the element platform' do
        expect(extension_element.platform).to eq(platform)
      end

      it 'sets the element properties' do
        expect(extension_element.properties).to eq([extension_property_element])
      end
    end
  end
end
