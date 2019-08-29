# multi_version_common_cartridge
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

require 'common_cartridge'

module MultiVersionCommonCartridge
  module Writers
    class ManifestOrganizationWriter
      # http://www.imsglobal.org/profile/cc/ccv1p3/ccv1p3_imscp_v1p2_v1p0.xsd
      # Organizations.Type, Organization.Type
      include SupportedVersions

      ORGANIZATION_STRUCTURE = 'rooted-hierarchy'.freeze
      DEFAULT_ROOT_ITEM_IDENTIFIER = 'root'.freeze

      MESSAGES = {
        no_identifier: 'An identifier is required'
      }.freeze

      attr_reader :cartridge

      def initialize(cartridge, factory, version)
        @cartridge = cartridge
        @factory = factory
        @version = validate_version(version)
      end

      def finalize
        validate_identifier
      end

      def organization_element
        CommonCartridge::Elements::Organizations::Organization.new.tap do |element|
          element.identifier = ''
          element.structure = ORGANIZATION_STRUCTURE
          element.root_item = root_item
        end
      end

      private def root_item
        CommonCartridge::Elements::Organizations::RootItem.new.tap do |root_item|
          root_item.identifier = cartridge.manifest.organization_identifier || DEFAULT_ROOT_ITEM_IDENTIFIER
          root_item.items = cartridge.items.map do |item|
            @factory.item_writer(item).organization_item_element
          end
        end
      end

      private def validate_identifier
        # raise StandardError, MESSAGES[:no_identifier] unless manifest..identifier
      end
    end
  end
end
