lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dns_adapter/version'

Gem::Specification.new do |spec|
  spec.name          = 'dns_adapter'
  spec.version       = DNSAdapter::VERSION
  spec.authors       = ['Peter M. Goldstein']
  spec.email         = ['peter@valimail.com']
  spec.summary       = 'An adapter layer for DNS queries.'
  spec.description   = 'An adapter layer for DNS queries.'
  spec.homepage      = 'https://github.com/ValiMail/dns_adapter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").select { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.3'

  # rubocop:disable Gemspec/DevelopmentDependencies
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'rspec', '>= 3.0'
  # rubocop:enable Gemspec/DevelopmentDependencies

  spec.metadata = {
    'rubygems_mfa_required' => 'true'
  }
end
