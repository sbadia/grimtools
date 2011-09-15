#!/usr/bin/ruby
# Author:: Sebastien Badia (<seb@sebian.fr>)
# Date:: Fri Jul 01 14:03:40 +0200 2011
# For generate kavlan config from api.
require 'yaml'

$cluster=ARGV[0]
if ARGV.length <1
  puts "Usage:\n kavlan-api.rb <cluster-name>\n"
  exit(0)
end

def lookup(filename, *keys, &block)
  config = {}
  config = YAML.load_file("/home/sbadia/dev/reference-repository/generators/input/nancy-#{$cluster}.yaml")
  if config.has_key?(filename)
    result = config[filename]
    if !keys.empty?
      while !keys.empty? do
        result = result[keys.shift]
          break if result.nil?
      end
    end
    if block
      block.call(result)
    else
      result
    end
  else
    raise ArgumentError, "Cannot fetch the values for '#{keys.inspect}' in the input file '#{filename}'. The config files you gave to me are: '#{config.keys.inspect}'."
  end
end

if $cluster == "graphene":
  nnodes = 144
elsif $cluster == "griffon":
  nnodes = 92
elsif $cluster == "talc":
  nnodes = 134
else
  puts "\nCluster: #{$cluster} unknow\n"
  exit(0)
end

nnodes.times do |i|
    node = "#{$cluster}-#{i+1}"
    puts "#{node}.nancy.grid5000.fr #{lookup(node, 'switch_pos_eth0')} #{lookup(node, 'switch_eth0')}"
end
