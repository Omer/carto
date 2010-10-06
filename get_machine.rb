#!/usr/bin/env ruby

require 'bin/carto'

puts "Enter machine name to get more info: "
machine = gets.chomp
puts get_room_by_machine(machine)
