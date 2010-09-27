#!/usr/bin/env ruby

require 'bin/carto'

puts get_room_by_machine('moose')
puts "press any key to continue..."
t = gets.chomp

machine = get_machine('aurora')
floor_map = get_floor_by_machine('aurora')
puts "list of all machines on floor #{machine['floor']} >>>"
floor_map.each {|room, machines|
	puts "Room: #{room}"
	machines.each {|machine| puts "\t#{machine}" }
	}

puts "press any key..."
t = gets.chomp
puts "Testing exit function"
machine = get_machine('yourmum')
