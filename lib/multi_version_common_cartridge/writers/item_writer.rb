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

module MultiVersionCommonCartridge
  module Writers
    class ItemWriter
      include SupportedVersions

      MESSAGES = {
        no_title: 'A title is required',
        no_identifier: 'An identifier is required'
      }.freeze

      attr_reader :item

      def initialize(item, factory, version)
        @item = item
        @factory = factory
        @version = validate_version(version)
      end

      def finalize
        validate_title
        validate_identifier
      end

      def organization_item_element
        CommonCartridge::Elements::Organizations::Item.new.tap do |item_element|
          item_element.identifier = item.identifier
          item_element.identifierref = item.resource.identifier if item.resource
          item_element.title = item.title
          item_element.items = item.children.map do |child|
            @factory.item_writer(child).organization_item_element
          end
        end
      end

      private def validate_title
        raise StandardError, MESSAGES[:no_title] unless item.title
      end

      private def validate_identifier
        raise StandardError, MESSAGES[:no_identifier] unless item.identifier
      end
    end
  end
end
