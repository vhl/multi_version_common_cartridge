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
    module SupportedVersions
      SUPPORTED_VERSIONS = [
        MultiVersionCommonCartridge::CartridgeVersions::CC_1_1_0,
        MultiVersionCommonCartridge::CartridgeVersions::CC_1_2_0,
        MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0,
        MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_2_0,
        MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_3_0
      ].freeze
      UNSUPPORTED_VERSION_MSG_TEMPLATE = "Unsupported common cartridge version '%<version>s'".freeze

      def validate_version(version)
        unless SUPPORTED_VERSIONS.include?(version)
          raise ArgumentError, format(UNSUPPORTED_VERSION_MSG_TEMPLATE, version: version)
        end
        version
      end
    end
  end
end
