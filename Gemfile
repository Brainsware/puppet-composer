source "https://rubygems.org"

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_VERSION'] || '~> 4.8.0'
  gem "rspec-puppet", '~> 2.5'
  gem "puppetlabs_spec_helper", '~> 1.2.2'
  gem "metadata-json-lint"
  gem "rspec-puppet-facts"
  gem "rspec"
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "vagrant-wrapper"
  gem "puppet-blacksmith"
  gem "guard-rake"
end

group :system_tests do
  gem "beaker"
  gem "beaker-rspec"
end
