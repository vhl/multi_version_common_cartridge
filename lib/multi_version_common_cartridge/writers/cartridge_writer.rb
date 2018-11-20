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
    class CartridgeWriter
      include SupportedVersions

      attr_reader :cartridge

      def initialize(cartridge, version)
        @cartridge = cartridge
        @finalized = false
        @version = validate_version(version)
      end

      def finalize
        manifest_writer.finalize
        cartridge.all_items.each { |item| item_writer(item).finalize }
        cartridge.all_resources.each { |resource| resource_writer(resource).finalize }
        @finalized = true
      end

      def write_in_dir(dir)
        # Should we raise, or should we call finalize from here?
        raise StandardError, 'the cartridge has not been finalized' unless @finalized
        FileUtils.mkdir_p(dir)
        manifest_writer.write(dir)
        cartridge.all_resources.each do |resource|
          resource_writer(resource).create_files(dir)
        end
      end

      def write_to_zip(filename)
        Dir.mktmpdir do |dir|
          write_in_dir(dir)
          zip_dir(filename, dir)
        end
      end

      private def zip_dir(filename, dir)
        Zip::OutputStream.open(filename) { |zos| } # make sure it's a zip

        Zip::File.open(filename, Zip::File::CREATE) do |zipfile|
          base_path = Pathname.new(dir)
          Dir["#{dir}/**/*"].each do |file|
            entry = Pathname.new(file).relative_path_from(base_path)
            zipfile.add(entry, file)
          end
        end
      end

      private def writers_factory
        @writers_factory ||= Factory.new(cartridge, @version)
      end

      private def manifest_writer
        writers_factory.manifest_writer
      end

      private def item_writer(item)
        writers_factory.item_writer(item)
      end

      private def resource_writer(resource)
        writers_factory.resource_writer(resource)
      end
    end
  end
end
