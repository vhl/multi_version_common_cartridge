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

class SaxMachineNokogiriXmlSaver
  def save(builder, object, name)
    sax_config = sax_config_for(object)
    unless sax_config
      builder.send(name, object)
      return
    end

    attrs = xml_attributes(object, sax_config)
    content = xml_content(object, sax_config)
    create_xml_node(builder, name, content, attrs) do |xml_element|
      sax_config.top_level_elements.each do |_, configs|
        configs.each do |config|
          as = config.instance_variable_get(:@as)
          save(xml_element, object.send(as), config.name)
        end
      end

      sax_config.collection_elements.each do |_, configs|
        configs.each do |config|
          as = config.instance_variable_get(:@as)
          object.send(as).each do |elm|
            save(xml_element, elm, config.name)
          end
        end
      end
    end
  end

  private def xml_attributes(object, sax_config)
    attrs = sax_config.top_level_attributes.map do |attr|
      [attr.name, object.send(attr.instance_variable_get(:@as))]
    end.to_h
    attrs.delete_if { |_, v| v.nil? }
  end

  private def xml_content(object, sax_config)
    return if sax_config.top_level_element_value.empty?
    element_value_config = sax_config.top_level_element_value.last
    object.send(element_value_config.name)
  end

  private def create_xml_node(builder, name, content, attrs, &block)
    if name.include?(':')
      namespace, name = name.split(':', 2)
      create_xml_element(builder[namespace], name, content, attrs, &block)
    else
      create_xml_element(builder, name, content, attrs, &block)
    end
  end

  private def create_xml_element(builder, name, content, attrs, &block)
    if content
      builder.send(name, content, attrs) do |xml_element|
        yield xml_element
      end
    else
      builder.send(name, attrs) do |xml_element|
        yield xml_element
      end
    end
  end

  private def sax_config_for(object)
    if object.class.respond_to?(:sax_config)
      object.class.sax_config
    end
  end
end
