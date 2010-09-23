#!/usr/bin/env ruby

require 'pathname'
require 'yaml'

APP_ROOT = File.join(File.dirname(Pathname.new(__FILE__).realpath),'/..')
LIB_ROOT = APP_ROOT + '/lib'

require LIB_ROOT + '/parser'

@data = YAML::load_file( @inventory )
puts @data[0][0]
