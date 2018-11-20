require 'spec_helper'
require 'multi_version_common_cartridge'

describe MultiVersionCommonCartridge::Writers::BasicLtiVendorWriter do
  let(:vendor) { MultiVersionCommonCartridge::Resources::BasicLtiLink::Vendor.new }
  let(:vendor_writer) { described_class.new(vendor, version) }
  let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
  let(:code) { 'some code' }
  let(:name) { 'some name' }
  let(:description) { 'some description' }
  let(:url) { 'some url' }
  let(:contact_email) { 'contact@example.com' }

  describe '#initialize' do
    context 'when a non supported version is specified,' do
      let(:version) { 'some random version' }

      it 'raises an error' do
        expect { vendor_writer }.to raise_error(
          ArgumentError,
          format(described_class::UNSUPPORTED_VERSION_MSG_TEMPLATE, version: version)
        )
      end
    end

    context 'when a supported version is specified,' do
      it 'does not raise an error' do
        described_class::SUPPORTED_VERSIONS.each do |version|
          expect { described_class.new(vendor, version) }.not_to raise_error
        end
      end
    end
  end

  describe '#finalize' do
    context 'when no code is set,' do
      it 'raises an error' do
        vendor.name = name
        vendor.contact_email = contact_email
        expect { vendor_writer.finalize }.to raise_error(
          StandardError,
          described_class::MESSAGES[:no_code]
        )
      end
    end

    context 'when a code is set,' do
      it 'does no raise an error' do
        vendor.code = code
        vendor.name = name
        vendor.contact_email = contact_email
        expect { vendor_writer.finalize }.not_to raise_error
      end
    end

    context 'when no name is set,' do
      it 'raises an error' do
        vendor.code = code
        vendor.contact_email = contact_email
        expect { vendor_writer.finalize }.to raise_error(
          StandardError,
          described_class::MESSAGES[:no_name]
        )
      end
    end

    context 'when a name is set,' do
      it 'does no raise an error' do
        vendor.code = code
        vendor.name = name
        vendor.contact_email = contact_email
        expect { vendor_writer.finalize }.not_to raise_error
      end
    end

    context 'when no contact_email is set,' do
      it 'raises an error' do
        vendor.code = code
        vendor.name = name
        expect { vendor_writer.finalize }.to raise_error(
          StandardError,
          described_class::MESSAGES[:no_contact_email]
        )
      end
    end

    context 'when a contact_email is set,' do
      it 'does no raise an error' do
        vendor.code = code
        vendor.name = name
        vendor.contact_email = contact_email
        expect { vendor_writer.finalize }.not_to raise_error
      end
    end
  end

  context 'when finalizing for version 1.3.0,' do
    let(:version) { MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 }
    let(:vendor_element) { vendor_writer.vendor_element }

    before do
      vendor.code = code
      vendor.name = name
      vendor.description = description
      vendor.url = url
      vendor.contact_email = contact_email
      vendor_writer.finalize
    end

    describe '#vendor_element' do
      it 'returns a basic lti link vendor element' do
        expect(vendor_element).to be_a(CommonCartridge::Elements::Resources::BasicLtiLink::Vendor)
      end

      it 'sets the element code' do
        expect(vendor_element.code).to eq(code)
      end

      it 'sets the element name' do
        expect(vendor_element.name).to eq(name)
      end

      it 'sets the element description' do
        expect(vendor_element.description).to eq(description)
      end

      it 'sets the element url' do
        expect(vendor_element.url).to eq(url)
      end

      describe 'the element contact email' do
        it 'is a vendor contact element' do
          expect(vendor_element.contact)
            .to be_a(CommonCartridge::Elements::Resources::BasicLtiLink::VendorContact)
        end

        it 'sets the contact email' do
          expect(vendor_element.contact.email).to eq(contact_email)
        end
      end
    end
  end
end
