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

def get_machine(hostname)
	unless @names[hostname].nil?
		return @names[hostname]
	else
		puts ">>> ERROR \n>>> Machine not found. Check your input."
		Process.exit(1)
	end
end

def get_floor(floor)
	unless @layout[floor].nil?
		return @layout[floor]
	else
		puts ">>> ERROR \n>>> Floor not found. Check your input."
		Process.exit(1)
	end
end

def get_room_by_machine(hostname)
	machine = get_machine(hostname)
	puts "machine is #{hostname}, on level #{machine['floor']}, in room #{machine['room']}"
	return @layout[machine['floor']][machine['room']]
end

def get_floor_by_machine(hostname)
	return get_floor(get_machine(hostname)['floor'])
end
