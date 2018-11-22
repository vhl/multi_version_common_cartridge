lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'multi_version_common_cartridge/version'

Gem::Specification.new do |spec|
  spec.name        = 'multi_version_common_cartridge'
  spec.version     = MultiVersionCommonCartridge::VERSION
  spec.authors     = ['Vista Higher Learning, Inc.']
  spec.email       = ['ops@vistahigherlearning.com']
  spec.summary     = 'Parses multiple versions of IMS Common Cartridge files ' \
                     'into ruby objects.'
  spec.description = 'Target versions supported: 1.1, 1.2, 1.3, Thin 1.3'
  spec.homepage    = 'https://github.com/vhl/multi_version_common_cartridge'

  spec.files = `git ls-files -z`.split("\x0").reject do |file|
    file.match(%r{^(test|spec|features)/})
  end

  spec.add_dependency 'activesupport', '> 2.0', '< 6.0'
  spec.add_dependency 'common_cartridge_parser', '1.0.0'

  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '0.58.2'
  spec.add_development_dependency 'rubocop-rspec', '1.30.0'
  spec.add_development_dependency 'simplecov', '~> 0.16'
end
