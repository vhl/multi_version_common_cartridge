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
    class BasicLtiExtensionWriter
      include SupportedVersions

      attr_reader :extension

      def initialize(extension, version)
        @extension = extension
        @version = validate_version(version)
      end

      def finalize
      end

      def extension_element
        @extension_element ||= CommonCartridge::Elements::Resources::BasicLtiLink::Extension.new.tap do |element|
          element.platform = extension.platform
          element.properties = extension.properties.map do |key, value|
            CommonCartridge::Elements::Resources::BasicLtiLink::ExtensionProperty.new(
              name: key, value: value
            )
          end
        end
      end
    end
  end
end

