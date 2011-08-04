#!/usr/bin/ruby
# Author:: Sebastien Badia (<sebastien.badia@inria.fr>)
# Date:: Fri Jul 01 10:47:49 +0200 2011
# Little script for generate dhcpd.conf from yaml conf of api.
require 'yaml'

$cluster=ARGV[0]
type=ARGV[1]
if ARGV.length <2
  puts "Usage:\n dhcpd.rb <cluster-name> <bmc/eth0/eth1>\n"
  exit(0)
end

def lookup(filename, *keys, &block)
  config = {}
  config = YAML.load_file("/home/sbadia/dev/reference-repository/generators/input/bordeaux-#{$cluster}.yaml")
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

if $cluster == "bordeplage":
  nnodes = 51
elsif $cluster == "bordereau":
  nnodes = 93
elsif $cluster == "borderline":
  nnodes = 10
else
  puts "\nCluster: #{$cluster} unknow\n"
  exit(0)
end

nnodes.times do |i|
  node = "#{$cluster}-#{i+1}"
  if type == "eth0":
    puts "host #{node}.bordeaux.grid5000.fr {"
  else
    puts "host #{node}-#{type}.bordeaux.grid5000.fr {"
  end
  puts "\tharware ethernet #{lookup("#{node}", 'network_interfaces',"#{type}", 'mac')};"
  puts "\toption host-name \"#{node}-bmc\";"
  puts "\tfixed-address #{lookup(node, 'network_interfaces', "#{type}", 'ip')};"
  puts "}"
end
