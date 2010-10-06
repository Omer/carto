#!/usr/bin/env ruby

require 'bin/carto'

puts get_room_by_machine('tay')
puts "press any key to continue..."
t = gets.chomp

machine = get_machine('sashko')
room_map = get_room_by_machine('sashko')
puts "list of all machines on floor #{machine['floor']} in room #{machine['room']} >>>"
room_map.each {|machines|
	machines.each {|machine| puts "\t#{machine}" }
	}

puts "press any key..."
t = gets.chomp

puts "get a room:"
room = get_room('4-12')
puts "list of all machines in room 4.12 >>>"
puts room

puts "Testing exit function"
machine = get_machine('yourmum')
