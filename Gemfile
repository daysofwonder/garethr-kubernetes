source "https://rubygems.org"

gem "kubeclient", '~> 4.6.0'
gem "recursive-open-struct", "1.0.5"
gem "hashdiff"

group :test do
  gem "rake", "~> 10.0"
  gem "puppet", ENV['PUPPET_GEM_VERSION'] || '~> 5.5'
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
  gem "clamp" # for puppet-swagger-generator
  gem "travis"
  gem "travis-lint"
  gem "puppet-blacksmith"
  gem "guard-rake"
  gem "pry"
  gem "pry-coolline"
  gem "awesome_print"
  gem "yard"
  gem "solargraph"
end
