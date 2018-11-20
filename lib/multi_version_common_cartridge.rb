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

require 'multi_version_common_cartridge/version'
require 'multi_version_common_cartridge/sax_machine_nokogiri_xml_saver'

require 'multi_version_common_cartridge/cartridge_versions'
require 'multi_version_common_cartridge/item'
require 'multi_version_common_cartridge/resources/resource'
require 'multi_version_common_cartridge/resources/basic_lti_link'
require 'multi_version_common_cartridge/manifest'
require 'multi_version_common_cartridge/cartridge'
require 'multi_version_common_cartridge/xml_definitions'
require 'multi_version_common_cartridge/writers/supported_versions'
require 'multi_version_common_cartridge/writers/item_writer'
require 'multi_version_common_cartridge/writers/resource_writer'
require 'multi_version_common_cartridge/writers/basic_lti_vendor_writer'
require 'multi_version_common_cartridge/writers/basic_lti_extension_writer'
require 'multi_version_common_cartridge/writers/basic_lti_link_writer'
require 'multi_version_common_cartridge/writers/manifest_writer'
require 'multi_version_common_cartridge/writers/manifest_metadata_writer'
require 'multi_version_common_cartridge/writers/manifest_organization_writer'
require 'multi_version_common_cartridge/writers/manifest_resources_writer'
require 'multi_version_common_cartridge/writers/cartridge_writer'
require 'multi_version_common_cartridge/writers/factory'
