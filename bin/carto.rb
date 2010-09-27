#!/usr/bin/env ruby

require 'pathname'
require 'yaml'

APP_ROOT = File.join(File.dirname(Pathname.new(__FILE__).realpath),'/..')
LIB_ROOT = APP_ROOT + '/lib'

require LIB_ROOT + '/parser'

File.open( @inventory ) do |yf|
	count = 1
	YAML.each_document( yf ) do |ydoc|
		if count == 1
			@names = ydoc
			count += 1
		else
			@layout = ydoc
		end
	end
end
