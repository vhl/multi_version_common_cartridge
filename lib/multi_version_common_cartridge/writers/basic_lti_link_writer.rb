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
    class BasicLtiLinkWriter < ResourceWriter
      REQUIRED_NAMESPACES = {
        MultiVersionCommonCartridge::CartridgeVersions::CC_1_1_0 => {
          'xmlns' => 'http://www.imsglobal.org/xsd/imslticc_v1p0',
          'xmlns:blti' => 'http://www.imsglobal.org/xsd/imsbasiclti_v1p0',
          'xmlns:lticm' => 'http://www.imsglobal.org/xsd/imslticm_v1p0',
          'xmlns:lticp' => 'http://www.imsglobal.org/xsd/imslticp_v1p0',
          'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
        },
        MultiVersionCommonCartridge::CartridgeVersions::CC_1_2_0 => {
          'xmlns' => 'http://www.imsglobal.org/xsd/imslticc_v1p2',
          'xmlns:blti' => 'http://www.imsglobal.org/xsd/imsbasiclti_v1p0',
          'xmlns:lticm' => 'http://www.imsglobal.org/xsd/imslticm_v1p0',
          'xmlns:lticp' => 'http://www.imsglobal.org/xsd/imslticp_v1p0',
          'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
        },
        MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 => {
          'xmlns' => 'http://www.imsglobal.org/xsd/imslticc_v1p3',
          'xmlns:blti' => 'http://www.imsglobal.org/xsd/imsbasiclti_v1p0',
          'xmlns:lticm' => 'http://www.imsglobal.org/xsd/imslticm_v1p0',
          'xmlns:lticp' => 'http://www.imsglobal.org/xsd/imslticp_v1p0',
          'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
        },
        MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_2_0 => {
          'xmlns' => 'http://www.imsglobal.org/xsd/imslticc_v1p2',
          'xmlns:blti' => 'http://www.imsglobal.org/xsd/imsbasiclti_v1p0',
          'xmlns:lticm' => 'http://www.imsglobal.org/xsd/imslticm_v1p0',
          'xmlns:lticp' => 'http://www.imsglobal.org/xsd/imslticp_v1p0',
          'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
        },
        MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_3_0 => {
          'xmlns' => 'http://www.imsglobal.org/xsd/imslticc_v1p3',
          'xmlns:blti' => 'http://www.imsglobal.org/xsd/imsbasiclti_v1p0',
          'xmlns:lticm' => 'http://www.imsglobal.org/xsd/imslticm_v1p0',
          'xmlns:lticp' => 'http://www.imsglobal.org/xsd/imslticp_v1p0',
          'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
        }
      }.freeze
      REQUIRED_SCHEMA_LOCATIONS = {
        MultiVersionCommonCartridge::CartridgeVersions::CC_1_1_0 => [
          [
            'http://www.imsglobal.org/xsd/imslticc_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticc_v1p0p1.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imsbasiclti_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imsbasiclti_v1p0p1.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imslticm_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticm_v1p0.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imslticp_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticp_v1p0.xsd'
          ]
        ],
        MultiVersionCommonCartridge::CartridgeVersions::CC_1_2_0 => [
          [
            'http://www.imsglobal.org/xsd/imslticc_v1p2',
            'http://www.imsglobal.org/xsd/lti/ltiv1p2/imslticc_v1p2.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imsbasiclti_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imsbasiclti_v1p0p1.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imslticm_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticm_v1p0.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imslticp_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticp_v1p0.xsd'
          ]
        ],
        MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 => [
          [
            'http://www.imsglobal.org/xsd/imslticc_v1p3',
            'http://www.imsglobal.org/xsd/lti/ltiv1p3/imslticc_v1p3.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imsbasiclti_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imsbasiclti_v1p0p1.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imslticm_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticm_v1p0.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imslticp_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticp_v1p0.xsd'
          ]
        ],
        MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_2_0 => [
          [
            'http://www.imsglobal.org/xsd/imslticc_v1p2',
            'http://www.imsglobal.org/xsd/lti/ltiv1p2/imslticc_v1p2.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imsbasiclti_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imsbasiclti_v1p0p1.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imslticm_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticm_v1p0.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imslticp_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticp_v1p0.xsd'
          ]
        ],
        MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_3_0 => [
          [
            'http://www.imsglobal.org/xsd/imslticc_v1p3',
            'http://www.imsglobal.org/xsd/lti/ltiv1p3/imslticc_v1p3.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imsbasiclti_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imsbasiclti_v1p0p1.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imslticm_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticm_v1p0.xsd'
          ],
          [
            'http://www.imsglobal.org/xsd/imslticp_v1p0',
            'http://www.imsglobal.org/xsd/lti/ltiv1p0/imslticp_v1p0.xsd'
          ]
        ]
      }.freeze
      MESSAGES = {
        no_title: 'A title is required.',
        no_secure_launch_url: 'A secure launch url is required.'
      }.freeze

      TYPE = {
        MultiVersionCommonCartridge::CartridgeVersions::CC_1_1_0 => 'imsbasiclti_xmlv1p0',
        MultiVersionCommonCartridge::CartridgeVersions::CC_1_2_0 => 'imsbasiclti_xmlv1p0',
        MultiVersionCommonCartridge::CartridgeVersions::CC_1_3_0 => 'imsbasiclti_xmlv1p3',
        MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_2_0 => 'imsbasiclti_xmlv1p0',
        MultiVersionCommonCartridge::CartridgeVersions::THIN_CC_1_3_0 => 'imsbasiclti_xmlv1p3'
      }.freeze
      BASIC_LTI_LINK_FILENAME = 'basic_lti_link.xml'.freeze

      def finalize
        super
        validate_title
        validate_secure_launch_url
        vendor_writer.finalize
      end

      def type
        TYPE[@version]
      end

      def files
        [
          File.join(resource_path, BASIC_LTI_LINK_FILENAME)
        ]
      end

      def create_files(out_dir)
        FileUtils.mkdir_p(File.join(out_dir, resource_path))
        doc = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |builder|
          SaxMachineNokogiriXmlSaver.new.save(
            builder, basic_lti_link_element, 'cartridge_basiclti_link'
          )
        end
        File.open(File.join(out_dir, resource_path, BASIC_LTI_LINK_FILENAME), 'w') do |file|
          file.write(doc.to_xml)
        end
      end

      def basic_lti_link_element
        @basic_lti_link_element ||=
          CommonCartridge::Elements::Resources::BasicLtiLink::BasicLtiLink.new.tap do |element|
            element.xmlns = required_namespaces['xmlns']
            element.xmlns_blti = required_namespaces['xmlns:blti']
            element.xmlns_lticm = required_namespaces['xmlns:lticm']
            element.xmlns_lticp = required_namespaces['xmlns:lticp']
            element.xmlns_xsi = required_namespaces['xmlns:xsi']
            element.xsi_schema_location = xsi_schema_location
            element.title = resource.title
            element.description = resource.description if resource.description
            element.secure_launch_url = resource.secure_launch_url
            element.vendor = vendor_writer.vendor_element
            element.extensions = extensions_element
          end
      end

      private def validate_title
        raise StandardError, MESSAGES[:no_title] unless resource.title
      end

      private def validate_secure_launch_url
        raise StandardError, MESSAGES[:no_secure_launch_url] unless resource.secure_launch_url
      end

      private def vendor_writer
        @vendor_writer ||= BasicLtiVendorWriter.new(resource.vendor, @version)
      end

      private def extensions_element
        resource.extensions.map do |extension|
          BasicLtiExtensionWriter.new(extension, @version).extension_element
        end
      end

      private def required_namespaces
        REQUIRED_NAMESPACES[@version]
      end

      private def xsi_schema_location
        locations = REQUIRED_SCHEMA_LOCATIONS[@version]
        locations.flatten.join(' ')
      end

      private def resource_path
        resource.identifier
      end
    end
  end
end
