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
    class ManifestMetadataWriter
      # http://www.imsglobal.org/profile/cc/ccv1p3/ccv1p3_imscp_v1p2_v1p0.xsd
      # ManifestMetadata.Type
      include SupportedVersions

      attr_reader :manifest

      def initialize(manifest, version)
        @manifest = manifest
        @version = validate_version(version)
      end

      def finalize
        # nothing to check
      end

      def metadata_element
        CommonCartridge::Elements::Metadata.new.tap do |metadata|
          metadata.schema = XmlDefinitions::SCHEMA[@version]
          metadata.schemaversion = XmlDefinitions::SCHEMA_VERSION[@version]
          metadata.lom = lom_element
        end
      end

      private def lom_element
        CommonCartridge::Elements::Lom::Lom.new.tap do |lom|
          lom.general = CommonCartridge::Elements::Lom::General.new.tap do |general|
            general.title = lom_general_title_element
          end
        end
      end

      private def lom_general_title_element
        CommonCartridge::Elements::Lom::Title.new.tap do |title_element|
          title_element.strings = manifest.titles.map do |language, value|
            CommonCartridge::Elements::Lom::LanguageString.new(language: language, value: value)
          end
        end
      end
    end
  end
end
