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
    class ManifestWriter
      include SupportedVersions

      MESSAGES = {
        no_identifier: 'An identifier is required',
      }.freeze

      attr_reader :manifest

      def initialize(manifest, factory, version)
        @manifest = manifest
        @factory = factory
        @version = validate_version(version)
      end

      def finalize
        raise StandardError, MESSAGES[:no_identifier] unless manifest.identifier
        metadata_writer.finalize
        organization_writer.finalize
        resources_writer.finalize
      end

      def write(dir)
        doc = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |builder|
          SaxMachineNokogiriXmlSaver.new.save(builder, manifest_element, 'manifest')
        end
        File.open(File.join(dir, 'imsmanifest.xml'), 'w') { |file| file.write(doc.to_xml) }
      end

      def manifest_element
        @manifest_element ||= CommonCartridge::Elements::Manifest.new.tap do |element|
          element.identifier = manifest.identifier
          element.xmlns = required_namespaces['xmlns']
          element.xmlns_lomimscc = required_namespaces['xmlns:lomimscc']
          element.xmlns_lom = required_namespaces['xmlns:lom']
          element.xmlns_xsi = required_namespaces['xmlns:xsi']
          element.xsi_schema_location = xsi_schema_location
          element.metadata = metadata_writer.metadata_element
          element.root_organization = CommonCartridge::Elements::Organizations::RootOrganization.new(
            organizations: [organization_writer.organization_element]
          )
          element.root_resource = resources_writer.root_resource_element
        end
      end

      private def metadata_writer
        @factory.manifest_metadata_writer
      end

      private def organization_writer
        @factory.manifest_organization_writer
      end

      private def resources_writer
        @factory.manifest_resources_writer
      end

      private def required_namespaces
        XmlDefinitions::REQUIRED_NAMESPACES[@version]
      end

      private def xsi_schema_location
        locations = XmlDefinitions::REQUIRED_SCHEMA_LOCATIONS[@version]
        locations.flatten.join(' ')
      end
    end
  end
end
