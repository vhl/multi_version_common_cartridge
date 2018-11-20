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

require 'common_cartridge'

module MultiVersionCommonCartridge
  module Writers
    class ManifestResourcesWriter
      # http://www.imsglobal.org/profile/cc/ccv1p3/ccv1p3_imscp_v1p2_v1p0.xsd
      # Resources.type
      include SupportedVersions

      attr_reader :cartridge

      def initialize(cartridge, factory, version)
        @cartridge = cartridge
        @factory = factory
        @resource_writers = {}
        @version = validate_version(version)
      end

      def finalize
        # nothing to check
      end

      def root_resource_element
        @root_resource_element ||= CommonCartridge::Elements::Resources::RootResource.new(
          resources: cartridge.all_resources.map do |resource|
            @factory.resource_writer(resource).resource_element
          end
        )
      end
    end
  end
end
