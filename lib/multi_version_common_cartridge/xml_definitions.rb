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
  module XmlDefinitions
    SCHEMA = {
      MultiVersionCommonCartridge::CartridgeVersions::CC_1_1_0 => 'IMS Common Cartridge',
      MultiVersionCommonCartridge::CartridgeVersions::CC_1_2_0 => 'IMS Common Cartridge',
      MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 => 'IMS Common Cartridge',
      MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_2_0 => 'IMS Thin Common Cartridge',
      MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_3_0 => 'IMS Thin Common Cartridge'
    }.freeze

    SCHEMA_VERSION = {
      MultiVersionCommonCartridge::CartridgeVersions::CC_1_1_0 => '1.1.0',
      MultiVersionCommonCartridge::CartridgeVersions::CC_1_2_0 => '1.2.0',
      MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 => '1.3.0',
      MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_2_0 => '1.2.0',
      MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_3_0 => '1.3.0'
    }.freeze

    REQUIRED_NAMESPACES = {
      MultiVersionCommonCartridge::CartridgeVersions::CC_1_1_0 => {
        'xmlns' => 'http://www.imsglobal.org/xsd/imsccv1p1/imscp_v1p1',
        'xmlns:lom' => 'http://ltsc.ieee.org/xsd/imsccv1p1/LOM/resource',
        'xmlns:lomimscc' => 'http://ltsc.ieee.org/xsd/imsccv1p1/LOM/manifest',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
      },
      MultiVersionCommonCartridge::CartridgeVersions::CC_1_2_0 => {
        'xmlns' => 'http://www.imsglobal.org/xsd/imsccv1p2/imscp_v1p1',
        'xmlns:lom' => 'http://ltsc.ieee.org/xsd/imsccv1p2/LOM/resource',
        'xmlns:lomimscc' => 'http://ltsc.ieee.org/xsd/imsccv1p2/LOM/manifest',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
      },
      MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 => {
        'xmlns' => 'http://www.imsglobal.org/xsd/imsccv1p3/imscp_v1p1',
        'xmlns:lom' => 'http://ltsc.ieee.org/xsd/imsccv1p3/LOM/resource',
        'xmlns:lomimscc' => 'http://ltsc.ieee.org/xsd/imsccv1p3/LOM/manifest',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
      },
      MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_2_0 => {
        'xmlns' => 'http://www.imsglobal.org/xsd/imsccv1p2/imscp_v1p1',
        'xmlns:lom' => 'http://ltsc.ieee.org/xsd/imsccv1p2/LOM/resource',
        'xmlns:lomimscc' => 'http://ltsc.ieee.org/xsd/imsccv1p2/LOM/manifest',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
      },
      MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_3_0 => {
        'xmlns' => 'http://www.imsglobal.org/xsd/imsccv1p3/imscp_v1p1',
        'xmlns:lom' => 'http://ltsc.ieee.org/xsd/imsccv1p3/LOM/resource',
        'xmlns:lomimscc' => 'http://ltsc.ieee.org/xsd/imsccv1p3/LOM/manifest',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
      }
    }.freeze

    REQUIRED_SCHEMA_LOCATIONS = {
      MultiVersionCommonCartridge::CartridgeVersions::CC_1_1_0 => [
        [
          'http://www.imsglobal.org/xsd/imsccv1p1/imscp_v1p1',
          'http://www.imsglobal.org/profile/cc/ccv1p1/ccv1p1_imscp_v1p2_v1p0.xsd'
        ],
        [
          'http://ltsc.ieee.org/xsd/imsccv1p1/LOM/resource',
          'http://www.imsglobal.org/profile/cc/ccv1p1/LOM/ccv1p1_lomresource_v1p0.xsd'
        ],
        [
          'http://ltsc.ieee.org/xsd/imsccv1p1/LOM/manifest',
          'http://www.imsglobal.org/profile/cc/ccv1p1/LOM/ccv1p1_lommanifest_v1p0.xsd'
        ]
      ],
      MultiVersionCommonCartridge::CartridgeVersions::CC_1_2_0 => [
        [
          'http://www.imsglobal.org/xsd/imsccv1p2/imscp_v1p1',
          'http://www.imsglobal.org/profile/cc/ccv1p2/ccv1p2_imscp_v1p2_v1p0.xsd'
        ],
        [
          'http://ltsc.ieee.org/xsd/imsccv1p2/LOM/resource',
          'http://www.imsglobal.org/profile/cc/ccv1p2/LOM/ccv1p2_lomresource_v1p0.xsd'
        ],
        [
          'http://ltsc.ieee.org/xsd/imsccv1p2/LOM/manifest',
          'http://www.imsglobal.org/profile/cc/ccv1p2/LOM/ccv1p2_lommanifest_v1p0.xsd'
        ]
      ],
      MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 => [
        [
          'http://www.imsglobal.org/xsd/imsccv1p3/imscp_v1p1',
          'http://www.imsglobal.org/profile/cc/ccv1p3/ccv1p3_imscp_v1p2_v1p0.xsd'
        ],
        [
          'http://www.imsglobal.org/xsd/imsccv1p3/imscsmd_v1p0',
          'http://www.imsglobal.org/profile/cc/ccv1p3/ccv1p3_imscsmd_v1p0.xsd'
        ],
        [
          'http://ltsc.ieee.org/xsd/imsccv1p3/LOM/resource',
          'http://www.imsglobal.org/profile/cc/ccv1p3/LOM/ccv1p3_lomresource_v1p0.xsd'
        ],
        [
          'http://ltsc.ieee.org/xsd/imsccv1p3/LOM/manifest',
          'http://www.imsglobal.org/profile/cc/ccv1p3/LOM/ccv1p3_lommanifest_v1p0.xsd'
        ]
      ],
      MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_2_0 => [
        [
          'http://www.imsglobal.org/xsd/imsccv1p2/imscp_v1p1',
          'http://www.imsglobal.org/profile/cc/ccv1p2/ccv1p2_imscp_v1p2_v1p0.xsd'
        ],
        [
          'http://ltsc.ieee.org/xsd/imsccv1p2/LOM/resource',
          'http://www.imsglobal.org/profile/cc/ccv1p2/LOM/ccv1p2_lomresource_v1p0.xsd'
        ],
        [
          'http://ltsc.ieee.org/xsd/imsccv1p2/LOM/manifest',
          'http://www.imsglobal.org/profile/cc/ccv1p2/LOM/ccv1p2_lommanifest_v1p0.xsd'
        ]
      ],
      MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_3_0 => [
        [
          'http://www.imsglobal.org/xsd/imsccv1p3/imscp_v1p1',
          'http://www.imsglobal.org/profile/cc/ccv1p3/ccv1p3_imscp_v1p2_v1p0.xsd'
        ],
        [
          'http://www.imsglobal.org/xsd/imsccv1p3/imscsmd_v1p0',
          'http://www.imsglobal.org/profile/cc/ccv1p3/ccv1p3_imscsmd_v1p0.xsd'
        ],
        [
          'http://ltsc.ieee.org/xsd/imsccv1p3/LOM/resource',
          'http://www.imsglobal.org/profile/cc/ccv1p3/LOM/ccv1p3_lomresource_v1p0.xsd'
        ],
        [
          'http://ltsc.ieee.org/xsd/imsccv1p3/LOM/manifest',
          'http://www.imsglobal.org/profile/cc/ccv1p3/LOM/ccv1p3_lommanifest_v1p0.xsd'
        ]
      ]
    }.freeze
  end
end
