#!/usr/bin/env ruby

require 'rubygems'
require 'mongo'
require 'pathname'

APP_ROOT = File.join(File.dirname(Pathname.new(__FILE__).realpath),'/..')
LIB_ROOT = APP_ROOT + '/lib'

@database = Mongo::Connection.new("localhost").db("machinedb")
@coll = @database["machineList"]

def add_machine(name, lab, floor, location)
	machine = {"name" => name, "lab" => lab, "floor" => floor, "location" => location, "updated" => "#{Time.now.strftime("%d/%m/%y - %H:%M:%S")}" }
	@coll.insert(machine)
end
def rename_machine(nameold, namenew)
	machine = @coll.find("name" => nameold)
	machine.name = "namenew"
	@database.machineList.update( { "name" => "nameold" }, { "name" => "namenew", "updated" => "#{Time.now.strftime("%d/%m/%y - %H:%M:%S")}" } )
end
def cleanup()
	name_list = []
	raw = @coll.find({}, {:fields => 'name'}).to_a.each { |item| name_list << item['name'] }
	duplicates = name_list.select{ |e| name_list.index(e) != name_list.rindex(e)}.uniq
	puts "duplicates removed >>> ", duplicates
	if duplicates.length > 0
		duplicates.each { |item| @coll.remove('name' => item) }
		cleanup()
	end
end

def get_machine_by_name(name)
	return @coll.find("name" => name) #.each { |row| puts row.inspect }
end
def get_machine_by_location(location)
	return @coll.find("location" => location)
end
def get_machines_in_lab(lab)
	return @coll.find("lab" => lab)
end
def get_machines_on_floor(floor)
	return @coll.find("floor" => floor)
end
