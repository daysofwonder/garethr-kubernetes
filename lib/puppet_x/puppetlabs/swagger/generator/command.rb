require 'json'
require 'erb'
require 'ostruct'
require 'fileutils'
require 'clamp'

require_relative "case"

EXCLUDE_TYPES = []

ALWAYS_EXCLUDE_PROPERTIES = %w(kind apiVersion)
EXCLUDE_PROPERTIES = OpenStruct.new(
   'secret' => ['stringData'],
)

module PuppetX
  module Puppetlabs
    module Swagger
      module Generator
        class Command < Clamp::Command
          option "--schema", "PATH", "Swagger Schema file", :environment_variable => "PUPPET_SWAGGER_SCHEMA"
          option "--out", "PATH", "Output directory", :environment_variable => "PUPPET_SWAGGER_OUTPUT"

          def execute
            signal_usage_error "Schema is required" unless schema
            signal_usage_error "Schema file must exist" unless File.file?(schema)
            signal_usage_error "Output directory must exist" unless Dir.exist?(out)

            file = File.read(schema)
            data = JSON.parse(file)

            if data['swagger'] == '2.0'
              # parse all POST apis and find objects that can be created
              # since it's enough for our usages
              data['paths'].each do |path, endpoint|
                # find POST endpoints
                next unless endpoint.include?("post")
                body = (endpoint['post']['parameters']||[]).find { |p| p['in'] == 'body' && p['name'] == 'body' }
                next unless body

                definition_name = body['schema']['$ref'].delete_prefix('#/definitions/')
                # find the associated model
                if data['definitions'][definition_name].nil?
                  puts "can't find definition #{definition_name}"
                  next
                end

                definition = data['definitions'][definition_name]
                name = definition['x-kubernetes-group-version-kind'][0]['version'] + "." + definition['x-kubernetes-group-version-kind'][0]['kind'] 
                group = definition['x-kubernetes-group-version-kind'][0]['group'] != '' ? definition['x-kubernetes-group-version-kind'][0]['group']  : 'core' 
                puts "generating: #{group}/#{name}"
                generate_name(name, definition)
              end
            else
              data['models'].each do |name, model|
                puts "generating: #{name}"
                generate_name(name, model)
              end
            end
          end

          def generate_name(name, model)
            formatted_name = format_for_type(name)
            unless EXCLUDE_TYPES.include? formatted_name
              generate_type(formatted_name, model)
              generate_provider(formatted_name, model)
            end
          end

          def format_for_type(name)
            name.gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase.split('.')[1]
          end

          def generate_type(name, model)
            generate(name, model, 'kubernetes', 'type')
          end

          def generate_provider(name, model)
            generate(name, model, 'kubernetes', 'provider')
          end

          def generate(name, model, namespace, thing)
            path = File.dirname(__FILE__) + "/templates/#{thing}.erb"
            template = ERB.new(File.new(path).read, 0, '-')
            vars = binding
            vars.local_variable_set(:name, name)
            vars.local_variable_set(:model, model)
            vars.local_variable_set(:type_exclusions, EXCLUDE_PROPERTIES)
            vars.local_variable_set(:all_exclusions, ALWAYS_EXCLUDE_PROPERTIES)
            vars.local_variable_set(:namespace, namespace)
            path = thing == 'provider' ? "lib/puppet/#{thing}/#{namespace}_#{name}" : "lib/puppet/#{thing}"
            FileUtils::mkdir_p File.join(out, path)
            file = thing == 'provider' ? "#{path}/swagger.rb" : "#{path}/#{namespace}_#{name}.rb"
            begin
              File.write(File.join(out, file), template.result(vars))
            rescue NoMethodError => e
              puts "issue with processing #{file}: #{e.message}"
            end
          end
        end
      end
    end
  end
end
