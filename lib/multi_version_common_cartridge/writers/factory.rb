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
    class Factory
      RESOURCE_WRITERS = {
        ::MultiVersionCommonCartridge::Resources::BasicLtiLink::BasicLtiLink => BasicLtiLinkWriter
      }.freeze

      def initialize(cartridge, version)
        @cartridge = cartridge
        @version = version
        @item_writers = {}
        @resource_writers = {}
      end

      def manifest_writer
        @manifest_writer ||= ManifestWriter.new(@cartridge.manifest, self, @version)
      end

      def manifest_metadata_writer
        @manifest_metadata_writer ||= ManifestMetadataWriter.new(@cartridge.manifest, @version)
      end

      def manifest_organization_writer
        @manifest_organization_writer ||= ManifestOrganizationWriter.new(@cartridge, self, @version)
      end

      def manifest_resources_writer
        @manifest_resources_writer ||= ManifestResourcesWriter.new(@cartridge, self, @version)
      end

      def item_writer(item)
        @item_writers[item] ||= ItemWriter.new(item, self, @version)
      end

      def resource_writer(resource)
        return @resource_writers[resource] if @resource_writers.key?(resource)
        writer_class = RESOURCE_WRITERS[resource.class]
        raise "Unknown resource '#{resource.class.name}'" unless writer_class
        @resource_writers[resource] = writer_class.new(resource, @version)
      end
    end
  end
end
