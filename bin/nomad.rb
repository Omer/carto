#!/usr/bin/env ruby

require 'pathname'

APP_ROOT = File.join(File.dirname(Pathname.new(__FILE__).realpath),'/..')
LIB_ROOT = APP_ROOT + '/lib'

require APP_ROOT + '/bin/carto'
require LIB_ROOT + '/colour'

def roomPrint(room, out)
	string ||= "Room is "+"#{room}\n".blue
	string << "Machines are:\n".blue
	out.each {|machine| string << "#{machine}\n" }
	return string
end

def machinePrint(machine, out)
	return "Machine is "+"#{machine}".blue+" in room "+"#{out['room']}".blue+" on floor "+"#{out['floor']}".blue
end

def floorPrint(floor, out)
	string ||= "Floor is "+"#{floor}\n".blue
	string << "Machines are:\n".blue
	out.each_value{|room| room.each {|machine| string << "#{machine}\n" }}
	return string
end

if ARGV.first.eql? "--help" or ARGV.first.eql? "-h"
	puts "Simple cli frontend to carto, allowing you to get info on a machine, room, or floor.".green
	puts "Usage:".green,"\tnomad -m [MACHINE1 MACHINE2 ..]".red+"\t# search for machine or machines".blue
	puts "\tnomad --machine [MACHINES]".red+"\t# search for machine/machines, as above".blue
	puts "\tnomad -f [FLOOR]".red+"\t# search for floor. Can be multiple floors, but output is long. Space-seperated.".blue
	puts "\tnomad --floor [FLOOR]".red+"\t# search for floor, as above".blue
	puts "\tnomad -r [FLOOR-ROOM]".red+"\t# search for room, in the format '3-12' or '4-07'. Can be multiple rooms.".blue
	puts "\tnomad --room [FLOOR-ROOM]".red+"\t# search for floor, as above".blue
	puts "Or, for interactive mode, run with no arguments.".green
elsif ARGV.first.eql? "-m" or ARGV.first.eql? "--machine"
	puts "---".blue
	ARGV[1..-1].each { |machine|
		begin
			out = get_machine(machine)
			puts machinePrint(machine,out)
			puts "---".red
		rescue
			puts "ERROR: >>>".red + " Machine "+"'#{machine}'".blue+" not found in current inventory."+" <<<".red
			puts "---".red
		end
	}
elsif ARGV.first.eql? "-f" or ARGV.first.eql? "--floor"
	puts "---".blue
	ARGV[1..-1].each { |floor|
		begin
			out = get_floor(floor)
			puts floorPrint(floor,out)
			puts "---".red
		rescue
			puts "ERROR: >>>".red + " Floor "+"'#{floor}'".blue+" not found in current inventory."+" <<<".red
			puts "---".red
		end
	}
elsif ARGV.first.eql? "-r" or ARGV.first.eql? "--room"
	puts "---".blue
	ARGV[1..-1].each { |room|
		begin
			out = get_room(room)
			puts roomPrint(room, out)
			puts "---".red
		rescue
			puts "ERROR: >>>".red + " Room "+"'#{room}'".blue+" not found in current inventory. Format should be '3-12', '4-07', etc."+" <<<".red
			puts "---".red
		end
	}
elsif ARGV.length == 0
	input = "foo"
	while input != ""
		puts "\n>>> Enter m for machine search, r for room search, f for floor search.  [m/r/f] >>>".green
		puts ">>> Hit enter to quit.".blue
		input = gets.chomp
		if input == "m"
			puts "\n>>> Enter machine name to get more info.".green
			machine = gets.chomp
			begin
				puts machinePrint(machine, get_machine(machine))
			rescue
				unless machine == ""
					puts "ERROR: >>>".red + " Machine "+"'#{machine}'".blue+" not found in current inventory. Please try again."+" <<<".red
				else
					puts "No machine entered...".red
				end
			end
		elsif input == "r"
			puts "\n>>> Enter room name to get more info. Format should be 4-01.".green
			room = gets.chomp
			begin
				puts roomPrint(room, get_room(room))
			rescue
				unless room == ""
					puts "ERROR: >>>".red + " Room "+"'#{room}'".blue+" not found in current inventory. Format should be '3-12', '4-07', etc."+" <<<".red
				else
					puts "No room entered...".red
				end
			end
		elsif input == "f"
			puts "\n>>> Enter floor number or letter to get more info. [case-sensitive, eg '3','B','5']".green
			floor = gets.chomp
			begin
				puts floorPrint(floor, get_floor(floor))
			rescue
				unless floor == ""
					puts "ERROR: >>>".red + " Floor "+"'#{floor}'".blue+" not found in current inventory."+" <<<".red
				else
					puts "No floor entered...".red
				end
			end
		elsif input == ""
			exit 0
		else
			puts "Malformed input. Please enter ONLY m, r, or f. The next prompt asks for details.".red
		end
	end
end
