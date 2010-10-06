#!/usr/bin/env ruby

require 'bin/carto'
require 'lib/colour'

if ARGV.length == 0
	machine = "foo"
	while machine != ""
		puts "\n>>> Enter machine name to get more info.".green
		puts ">>> Hit enter to quit.".blue
		machine = gets.chomp
		begin
			puts get_room_by_machine(machine)
		rescue
			unless machine == ""
				puts "ERROR: >>>".red + " Machine "+"'#{machine}'".blue+" not found in current inventory. Please try again."+" <<<".red
			else
				puts "No machine entered. Exiting...".red
			end
		end
	end
elsif ARGV.first.eql? "--help" or ARGV.first.eql? "-h"
	puts "Simple program to get the room, and floor of a machine.".blue
	puts "Usage:".blue,"\tget_machine [MACHINES]".red
	puts "Or, for interactive mode, run with no arguments.".blue
else
	puts "---".blue
	ARGV.each { |machine|
		begin
			puts get_room_by_machine(machine)
			puts "---".red
		rescue
			puts "ERROR: >>>".red + " Machine "+"'#{machine}'".blue+" not found in current inventory."+" <<<".red
			puts "---".red
		end
	}
end
