require 'spec_helper'
require 'multi_version_common_cartridge'

describe MultiVersionCommonCartridge::Writers::ManifestMetadataWriter do
  let(:manifest) { MultiVersionCommonCartridge::Manifest.new }
  let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
  let(:writer) { described_class.new(manifest, version) }

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
          expect { described_class.new(manifest, version) }.not_to raise_error
        end
      end
    end
  end

  describe '#finalize' do
    it 'does not raise an error' do
      expect { writer.finalize }.not_to raise_error
    end
  end

  context 'when finalizing for version 1.3.0,' do
    let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }

    describe '#metadata_element' do
      it 'returns a metadata element' do
        writer.finalize
        expect(writer.metadata_element).to be_a(CommonCartridge::Elements::Metadata)
      end

      it 'sets the schema element' do
        writer.finalize
        expect(writer.metadata_element.schema).to eq('IMS Common Cartridge')
      end

      it 'sets the schema version to the correct version' do
        writer.finalize
        expect(writer.metadata_element.schemaversion).to eq('1.3.0')
      end

      context 'when no title are set,' do
        it 'sets lom:title to empty' do
          writer.finalize
          expect(writer.metadata_element.lom.general.title.values).to be_empty
        end
      end

      context 'when a title is set,' do
        it 'adds an entry to the lom:title for each title' do
          manifest.set_title('Good morning', language: 'en-US')
          manifest.set_title('Bonjour', language: 'fr-FR')

          writer.finalize
          expect(writer.metadata_element.lom.general.title.values).to eq(
            manifest.titles
          )
        end
      end
    end
  end

  context 'when finalizing for version thin 1.3.0,' do
    let(:version) { MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_3_0 }

    describe '#metadata_element' do
      it 'returns a metadata element' do
        writer.finalize
        expect(writer.metadata_element).to be_a(CommonCartridge::Elements::Metadata)
      end

      it 'sets the schema element' do
        writer.finalize
        expect(writer.metadata_element.schema).to eq('IMS Thin Common Cartridge')
      end

      it 'sets the schema version to the correct version' do
        writer.finalize
        expect(writer.metadata_element.schemaversion).to eq('1.3.0')
      end

      context 'when no title are set,' do
        it 'sets lom:title to empty' do
          writer.finalize
          expect(writer.metadata_element.lom.general.title.values).to be_empty
        end
      end

      context 'when a title is set,' do
        it 'adds an entry to the lom:title for each title' do
          manifest.set_title('Good morning', language: 'en-US')
          manifest.set_title('Bonjour', language: 'fr-FR')

          writer.finalize
          expect(writer.metadata_element.lom.general.title.values).to eq(
            manifest.titles
          )
        end
      end
    end
  end
end
