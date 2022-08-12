require 'spec_helper'
require 'multi_version_common_cartridge'

describe MultiVersionCommonCartridge::Writers::BasicLtiLinkWriter do
  let(:basic_lti_link) { MultiVersionCommonCartridge::Resources::BasicLtiLink::BasicLtiLink.new }
  let(:basic_lti_link_writer) { described_class.new(basic_lti_link, version) }
  let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
  let(:identifier) { 'some identifier' }
  let(:title) { 'some title' }
  let(:description) { 'some description' }
  let(:secure_launch_url) { 'some secure launch url' }
  let(:vendor_writer) { instance_double(MultiVersionCommonCartridge::Writers::BasicLtiVendorWriter) }
  let(:vendor_element) { CommonCartridge::Elements::Resources::BasicLtiLink::Vendor.new }
  let(:extension) { MultiVersionCommonCartridge::Resources::BasicLtiLink::Extension.new('canvas') }
  let(:extension_writer) { instance_double(MultiVersionCommonCartridge::Writers::BasicLtiExtensionWriter) }
  let(:extension_element) { CommonCartridge::Elements::Resources::BasicLtiLink::Extension.new }

  before do
    allow(MultiVersionCommonCartridge::Writers::BasicLtiVendorWriter)
      .to receive(:new).with(basic_lti_link.vendor, version).and_return(vendor_writer)
    allow(vendor_writer).to receive(:finalize)
    allow(vendor_writer).to receive(:vendor_element).and_return(vendor_element)
    allow(MultiVersionCommonCartridge::Writers::BasicLtiExtensionWriter)
      .to receive(:new).with(extension, version).and_return(extension_writer)
    allow(extension_writer).to receive(:extension_element).and_return(extension_element)
  end

  describe '#initialize' do
    context 'when a non supported version is specified,' do
      let(:version) { 'some random version' }

      it 'raises an error' do
        expect { basic_lti_link_writer }.to raise_error(
          ArgumentError,
          format(described_class::UNSUPPORTED_VERSION_MSG_TEMPLATE, version: version)
        )
      end
    end

    context 'when a supported version is specified,' do
      it 'does not raise an error' do
        described_class::SUPPORTED_VERSIONS.each do |version|
          expect { described_class.new(basic_lti_link, version) }.not_to raise_error
        end
      end
    end
  end

  describe '#finalize' do
    context 'when no identifier is set,' do
      it 'creates a random identifier' do
        basic_lti_link.title = title
        basic_lti_link.secure_launch_url = secure_launch_url
        basic_lti_link.launch_url = secure_launch_url
        basic_lti_link_writer.finalize
        expect(basic_lti_link.identifier).not_to be_empty
      end
    end

    context 'when an identifier is set,' do
      it 'does not change the identifier' do
        basic_lti_link.identifier = identifier
        basic_lti_link.title = title
        basic_lti_link.secure_launch_url = secure_launch_url
        basic_lti_link.launch_url = secure_launch_url
        basic_lti_link_writer.finalize
        expect(basic_lti_link.identifier).to eq(identifier)
      end
    end

    context 'when no title is set,' do
      it 'raises an error' do
        basic_lti_link.identifier = identifier
        basic_lti_link.secure_launch_url = secure_launch_url
        basic_lti_link.launch_url = secure_launch_url
        expect { basic_lti_link_writer.finalize }.to raise_error(
          StandardError,
          described_class::MESSAGES[:no_title]
        )
      end
    end

    context 'when a title is set,' do
      it 'does not raise an error' do
        basic_lti_link.identifier = identifier
        basic_lti_link.title = title
        basic_lti_link.secure_launch_url = secure_launch_url
        basic_lti_link.launch_url = secure_launch_url
        expect { basic_lti_link_writer.finalize }.not_to raise_error
      end
    end

    it 'calls #finalize on the vendor writer' do
      basic_lti_link.identifier = identifier
      basic_lti_link.title = title
      basic_lti_link.secure_launch_url = secure_launch_url
      basic_lti_link.launch_url = secure_launch_url
      basic_lti_link_writer.finalize
      expect(vendor_writer).to have_received(:finalize)
    end
  end

  context 'when finalizing for version 1.3.0,' do
    let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
    let(:lti_element) { basic_lti_link_writer.basic_lti_link_element }

    before do
      basic_lti_link.identifier = identifier
      basic_lti_link.title = title
      basic_lti_link.description = description
      basic_lti_link.secure_launch_url = secure_launch_url
      basic_lti_link_writer.finalize
    end

    describe '#basic_lti_link_element' do
      let(:required_namespaces) do
        described_class::REQUIRED_NAMESPACES[version]
      end
      let(:required_schema_locations) do
        described_class::REQUIRED_SCHEMA_LOCATIONS[version]
      end

      it 'returns a basic lti link element' do
        expect(lti_element).to be_a(CommonCartridge::Elements::Resources::BasicLtiLink::BasicLtiLink)
      end

      it 'sets the required xml namespaces' do
        expect(lti_element.xmlns).to eq(
          required_namespaces['xmlns']
        )
        expect(lti_element.xmlns_blti).to eq(
          required_namespaces['xmlns:blti']
        )
        expect(lti_element.xmlns_lticm).to eq(
          required_namespaces['xmlns:lticm']
        )
        expect(lti_element.xmlns_lticp).to eq(
          required_namespaces['xmlns:lticp']
        )
        expect(lti_element.xmlns_xsi).to eq(
          required_namespaces['xmlns:xsi']
        )
        expect(lti_element.xsi_schema_location).to eq(
          required_schema_locations.flatten.join(' ')
        )
      end

      it 'sets the basic lti link element title' do
        expect(lti_element.title).to eq(title)
      end

      it 'sets the basic lti link element description' do
        expect(lti_element.description).to eq(description)
      end

      it 'sets the basic lti link element secure launch url' do
        expect(lti_element.secure_launch_url).to eq(secure_launch_url)
      end

      it 'sets the basic lti link element vendor' do
        expect(lti_element.vendor).to eq(vendor_element)
      end

      it 'sets the basic lti link element extensions' do
        basic_lti_link.extensions << extension
        expect(lti_element.extensions).to eq([extension_element])
      end
    end
  end

  context 'when finalizing for version 1.3.0,' do
    let(:version) { MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_3_0 }
    let(:lti_element) { basic_lti_link_writer.basic_lti_link_element }

    before do
      basic_lti_link.identifier = identifier
      basic_lti_link.title = title
      basic_lti_link.description = description
      basic_lti_link.secure_launch_url = secure_launch_url
      basic_lti_link_writer.finalize
    end

    describe '#basic_lti_link_element' do
      let(:required_namespaces) do
        described_class::REQUIRED_NAMESPACES[version]
      end
      let(:required_schema_locations) do
        described_class::REQUIRED_SCHEMA_LOCATIONS[version]
      end

      it 'returns a basic lti link element' do
        expect(lti_element).to be_a(CommonCartridge::Elements::Resources::BasicLtiLink::BasicLtiLink)
      end

      it 'sets the required xml namespaces' do
        expect(lti_element.xmlns).to eq(
          required_namespaces['xmlns']
        )
        expect(lti_element.xmlns_blti).to eq(
          required_namespaces['xmlns:blti']
        )
        expect(lti_element.xmlns_lticm).to eq(
          required_namespaces['xmlns:lticm']
        )
        expect(lti_element.xmlns_lticp).to eq(
          required_namespaces['xmlns:lticp']
        )
        expect(lti_element.xmlns_xsi).to eq(
          required_namespaces['xmlns:xsi']
        )
        expect(lti_element.xsi_schema_location).to eq(
          required_schema_locations.flatten.join(' ')
        )
      end

      it 'sets the basic lti link element title' do
        expect(lti_element.title).to eq(title)
      end

      it 'sets the basic lti link element description' do
        expect(lti_element.description).to eq(description)
      end

      it 'sets the basic lti link element secure launch url' do
        expect(lti_element.secure_launch_url).to eq(secure_launch_url)
      end

      it 'sets the basic lti link element launch url' do
        expect(lti_element.launch_url).to eq(secure_launch_url)
      end

      it 'sets the basic lti link element vendor' do
        expect(lti_element.vendor).to eq(vendor_element)
      end

      it 'sets the basic lti link element extensions' do
        basic_lti_link.extensions << extension
        expect(lti_element.extensions).to eq([extension_element])
      end
    end
  end

  describe '#create_files' do
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

      basic_lti_link.identifier = identifier
    end

    it 'creates a sub directory with the resource identifier' do
      Dir.mktmpdir do |dir|
        sub_dir = File.join(dir, basic_lti_link.identifier)
        basic_lti_link_writer.create_files(dir)
        expect(File).to be_directory(sub_dir)
      end
    end

    it 'creates a xml file with the basic lti link element' do
      Dir.mktmpdir do |dir|
        sub_dir = File.join(dir, basic_lti_link.identifier)
        basic_lti_filename = File.join(sub_dir, 'basic_lti_link.xml')
        basic_lti_link_writer.create_files(dir)
        expect(File.read(basic_lti_filename)).to eq(xml_content)
      end
    end
  end
end
