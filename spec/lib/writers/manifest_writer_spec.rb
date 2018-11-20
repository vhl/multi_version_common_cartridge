require 'spec_helper'
require 'multi_version_common_cartridge'

describe MultiVersionCommonCartridge::Writers::ManifestWriter do
  let(:cartridge) { MultiVersionCommonCartridge::Cartridge.new }
  let(:manifest) { cartridge.manifest }
  let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
  let(:metadata_writer) do
    instance_double(MultiVersionCommonCartridge::Writers::ManifestMetadataWriter)
  end
  let(:metadata_element) { CommonCartridge::Elements::Metadata.new }
  let(:organization_writer) do
    instance_double(MultiVersionCommonCartridge::Writers::ManifestOrganizationWriter)
  end
  let(:organization_element) { CommonCartridge::Elements::Organizations::Organization.new }
  let(:resources_writer) do
    instance_double(MultiVersionCommonCartridge::Writers::ManifestResourcesWriter)
  end
  let(:root_resource_element) { CommonCartridge::Elements::Resources::RootResource.new }
  let(:writers_factory) do
    instance_double(MultiVersionCommonCartridge::Writers::Factory)
  end
  let(:manifest_writer) { described_class.new(manifest, writers_factory, version) }

  before do
    allow(metadata_writer).to receive(:finalize)
    allow(metadata_writer).to receive(:metadata_element).and_return(metadata_element)
    allow(organization_writer).to receive(:finalize)
    allow(organization_writer).to receive(:organization_element).and_return(organization_element)
    allow(resources_writer).to receive(:finalize)
    allow(resources_writer).to receive(:root_resource_element).and_return(root_resource_element)
    allow(writers_factory).to receive(:manifest_metadata_writer).and_return(metadata_writer)
    allow(writers_factory).to receive(:manifest_organization_writer).and_return(organization_writer)
    allow(writers_factory).to receive(:manifest_resources_writer).and_return(resources_writer)
  end

  describe '#initialize' do
    context 'when a non supported version is specified,' do
      let(:version) { 'some random version' }

      it 'raises an error' do
        expect { manifest_writer }.to raise_error(
          ArgumentError,
          format(described_class::UNSUPPORTED_VERSION_MSG_TEMPLATE, version: version)
        )
      end
    end

    context 'when a supported version is specified,' do
      it 'does not raise an error' do
        described_class::SUPPORTED_VERSIONS.each do |version|
          factory = MultiVersionCommonCartridge::Writers::Factory.new(cartridge, version)
          expect { described_class.new(manifest, factory, version) }.not_to raise_error
        end
      end
    end
  end

  describe '#finalize' do
    context 'when no identifier is set,' do
      it 'raises an error' do
        expect { manifest_writer.finalize }.to raise_error(
          StandardError,
          described_class::MESSAGES[:no_identifier]
        )
      end
    end

    context 'when an identifier is set,' do
      before do
        cartridge.manifest.identifier = 'some identifier'
      end

      it 'calls #finalize on the manifest metadata writer' do
        manifest_writer.finalize
        expect(metadata_writer).to have_received(:finalize)
      end

      it 'calls #finalize on the manifest organization writer' do
        manifest_writer.finalize
        expect(organization_writer).to have_received(:finalize)
      end

      it 'calls #finalize on the manifest resources writer' do
        manifest_writer.finalize
        expect(resources_writer).to have_received(:finalize)
      end
    end
  end

  context 'when finalizing for version 1.3.0,' do
    let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }

    before do
      manifest.identifier = 'some identifier'
      manifest_writer.finalize
    end

    describe '#manifest_element' do
      let(:manifest_element) { manifest_writer.manifest_element }
      let(:required_namespaces) do
        MultiVersionCommonCartridge::XmlDefinitions::REQUIRED_NAMESPACES[version]
      end
      let(:required_schema_locations) do
        MultiVersionCommonCartridge::XmlDefinitions::REQUIRED_SCHEMA_LOCATIONS[version]
      end

      it 'returns a manifest element' do
        expect(manifest_writer.manifest_element).to be_a(CommonCartridge::Elements::Manifest)
      end

      it 'sets the manifest identifier' do
        expect(manifest_element.identifier).to eq(manifest.identifier)
      end

      it 'sets the required manifest xml namespaces' do
        expect(manifest_element.xmlns_lom).to eq(
          required_namespaces['xmlns:lom']
        )
        expect(manifest_element.xmlns_lomimscc).to eq(
          required_namespaces['xmlns:lomimscc']
        )
        expect(manifest_element.xmlns_xsi).to eq(
          required_namespaces['xmlns:xsi']
        )
        expect(manifest_element.xsi_schema_location).to eq(
          required_schema_locations.flatten.join(' ')
        )
      end

      it 'sets the manifest metadata element' do
        expect(manifest_element.metadata).to eq(metadata_element)
      end

      it 'sets the manifest root organization' do
        expect(manifest_element.root_organization).to be_a(
          CommonCartridge::Elements::Organizations::RootOrganization
        )
      end

      it 'sets the manifest root organization content from the manifest_organization writer' do
        expect(manifest_element.root_organization.organizations).to eq([organization_element])
      end

      it 'sets the manifest root resource' do
        expect(manifest_element.root_resource).to eq(root_resource_element)
      end
    end
  end

  describe '#write' do
    let(:nokogiri_builder) { instance_double(Nokogiri::XML::Builder) }
    let(:xml_saver) { instance_double(SaxMachineNokogiriXmlSaver) }
    let(:xml_content) { 'xml content' }

    before do
      allow(Nokogiri::XML::Builder)
        .to receive(:new)
        .with(encoding: 'UTF-8')
        .and_yield(nokogiri_builder)
        .and_return(nokogiri_builder)
      allow(SaxMachineNokogiriXmlSaver).to receive(:new).and_return(xml_saver)
      allow(xml_saver).to receive(:save)
      allow(nokogiri_builder).to receive(:to_xml).and_return(xml_content)
    end

    it 'saves the manifest element into a file' do
      Dir.mktmpdir do |dir|
        manifest_filename = File.join(dir, 'imsmanifest.xml')
        manifest_writer.write(dir)
        # expect(xml_saver).to have_received(:save)
        # expect(File).to be_file(manifest_filename)
        expect(File.read(manifest_filename)).to eq(xml_content)
      end
    end
  end
end
