# multi_version_common_cartridge
# Copyright © 2019 Remy Obein <remy@cassia.tech>
# Copyright © 2019 Vista Higher Learning, Inc.
#
# multi_version_common_cartridge is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# multi_version_common_cartridge is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with multi_version_common_cartridge.  If not, see <http://www.gnu.org/licenses/>.

module MultiVersionCommonCartridge
  module Writers
    class BasicLtiVendorWriter
      include SupportedVersions

      MESSAGES = {
        no_code: 'A code is required.',
        no_name: 'A name is required.',
        no_contact_email: 'A contact email is required.'
      }.freeze

      attr_reader :vendor

      def initialize(vendor, version)
        @vendor = vendor
        @version = validate_version(version)
      end

      def finalize
        validate_code
        validate_name
        validate_contact_email
      end

      def vendor_element
        @vendor_element ||= CommonCartridge::Elements::Resources::BasicLtiLink::Vendor.new.tap do |element|
          element.code = vendor.code
          element.name = vendor.name
          element.description = vendor.description if vendor.description
          element.url = vendor.url if vendor.url
          element.contact = CommonCartridge::Elements::Resources::BasicLtiLink::VendorContact.new(
            email: vendor.contact_email
          )
        end
      end

      private def validate_code
        raise StandardError, MESSAGES[:no_code] unless vendor.code
      end

      private def validate_name
        raise StandardError, MESSAGES[:no_name] unless vendor.name
      end

      private def validate_contact_email
        raise StandardError, MESSAGES[:no_contact_email] unless vendor.contact_email
      end
    end
  end
end
