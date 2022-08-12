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
  module Resources
    module BasicLtiLink
      class Vendor
        attr_accessor :code, :name, :description, :url, :contact_email
      end

      class BasicLtiLink < MultiVersionCommonCartridge::Resources::Resource
        attr_accessor :title, :description, :secure_launch_url, :extensions, :launch_url

        def initialize
          @extensions = []
        end

        def vendor
          @vendor ||= Vendor.new
        end
      end

      class Extension
        attr_accessor :platform, :properties

        def initialize(platform)
          @platform = platform
          @properties = {}
        end
      end
    end
  end
end
