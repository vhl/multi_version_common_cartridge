# multi_version_common_cartridge
A gem for writing different versions of Common Cartridges.

It supports Common Cartridge version 1.1, 1.2, 1.3 and Thin CC version 1.2 and 1.3.

## Usage
``` ruby
require 'multi_version_common_cartridge'

# Create a Common Cartridge
cartridge = MultiVersionCommonCartridge::Cartridge.new
cartridge.manifest.set_title('My cartridge')
cartridge.manifest.identifier = 'My cartridge identifier'
cartridge.items = [
  MultiVersionCommonCartridge::Item.new.tap do |item|
    item.title = 'My activity'
    item.identifier = 'Some identifier'
    item.resource = MultiVersionCommonCartridge::Resources::BasicLtiLink::BasicLtiLink.new.tap do |lti|
      lti.title = 'My activity title'
      lti.identifier = 'My activity identifier'
      lti.secure_launch_url = 'https://example.com/lti'
      lti.vendor.code = 'my_vendor_code'
      lti.vendor.name = 'My vendor name'
      lti.vendor.contact_email = 'email@vendor.com'
    end
  end
]

# Create a Common Cartridge writer for version 1.2.0
writer = MultiVersionCommonCartridge::Writers::CartridgeWriter.new(
  cartridge, '1.2.0'
)

# Finalize the Common Cartridge for the specified version.
writer.finalize

# Write the Common Cartridge
writer.write_to_zip('cartridge.imscc')
```
