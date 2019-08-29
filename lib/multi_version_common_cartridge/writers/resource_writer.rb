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
    class ResourceWriter
      include SupportedVersions

      attr_reader :resource

      def initialize(resource, version)
        @resource = resource
        @version = validate_version(version)
      end

      def finalize
        resource.identifier ||= 'i_' + Digest::MD5.hexdigest("resource #{resource.object_id}")
      end

      def resource_element
        CommonCartridge::Elements::Resources::Resource.new.tap do |element|
          element.identifier = resource.identifier
          element.type = type
          element.files = files.map do |file|
            CommonCartridge::Elements::Resources::File.new(href: file)
          end
        end
      end

      def type
        raise NotImplementedError, 'Subclasses must implement the type method ' \
        'that returns the correct resource type.'
      end

      def files
        []
      end
    end
  end
end
