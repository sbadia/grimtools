#!/usr/bin/ruby
require 'yaml'

 def lookup(filename, *keys, &block)
  config = {}
  config = YAML.load_file('/home/sbadia/dev/reference-repository/generators/input/nancy-graphene.yaml')
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
144.times do |i|
    node = "graphene-#{i+1}"
    puts "#{node}.nancy.grid5000.fr #{lookup(node, 'switch_pos_eth0')} #{lookup(node, 'switch_eth0')}"
end
