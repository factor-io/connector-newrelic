# encoding: UTF-8
$LOAD_PATH.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'factor-connector-newrelic'
  s.version       = '3.0.0'
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Maciej Skierkowski']
  s.email         = ['maciej@factor.io']
  s.homepage      = 'https://factor.io'
  s.summary       = 'NewRelic Factor.io Connector'
  s.files         = ['lib/factor-connector-newrelic.rb']
  
  s.require_paths = ['lib']

  s.add_runtime_dependency 'newrelic-metrics', '~> 0.1.10'
  s.add_runtime_dependency 'chronic', '~> 0.10.2'

  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.4.7'
  s.add_development_dependency 'rspec', '~> 3.2.0'
  s.add_development_dependency 'rake', '~> 10.4.2'
end