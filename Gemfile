source "https://rubygems.org"

gem "kubeclient", '~> 2.5.0'
gem "recursive-open-struct", "1.0.5"

group :test do
  gem "rake", "~> 10.0"
  gem "puppet", ENV['PUPPET_GEM_VERSION'] || '~> 5'
  gem "semantic_puppet"
  gem "puppet-lint"
  gem "puppet-lint-unquoted_string-check"
  gem "rspec-puppet"
  gem "puppet-syntax"
  gem "puppetlabs_spec_helper"
  gem "metadata-json-lint"
  gem "rspec"
  gem "CFPropertyList"
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "puppet-blacksmith"
  gem "guard-rake"
  gem "pry"
  gem "yard"
end
