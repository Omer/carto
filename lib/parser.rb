#!/usr/bin/env ruby

require 'net/http'
require 'rexml/document'
include REXML

PROFILENAME = APP_ROOT + '/hosts/inventory.xml'
YAMLNAME = APP_ROOT + '/hosts/inventory.yaml'

puts ">>> Carto library loaded. Getting information..."
def self.get_inventory
	unless FileTest.exist?(YAMLNAME) and File.mtime(YAMLNAME) > (Time.now - 86400)
		# check for net connection
		# unless `ping -t 5 lcfg.inf.ed.ac.uk`
			puts ">>> Inventory out of date. Reacquiring data from the server..."
			unless FileTest.exist?(PROFILENAME)
				Net::HTTP.start('lcfg.inf.ed.ac.uk') { |http|
					resp = http.get('/profiles/inf.ed.ac.uk/inventory/XMLInventory/profile.xml')
					open(PROFILENAME, 'w') { |file|
						file.write(resp.body)
					}
				}
				puts ">>> Reacquisition complete."
			end
			return parse_me( Document.new(File.new(PROFILENAME)) )
		#else 
		#	puts "No net connection. Falling back to saved file."
		#end
	end
	puts ">>> Inventory loaded. <<<"
	return YAMLNAME
end

def self.parse_me(invo)
	name_map = Hash.new
	floor_map = Hash.new
	room_map = Hash.new

	invo.elements.each('inventory/node') { |element| 
		machine_loc = element.elements["location"].text
		unless machine_loc.nil?
			if machine_loc[0..1] == "AT"
				machine_floor = machine_loc[3,1]
				machine_room = machine_loc[5..-1]
				machine_name = element.attributes["name"]
				name_map["#{machine_name}"] = {'floor' => machine_floor, 'room' => machine_room}
				
				((floor_map["#{machine_floor}"] ||= {} )["#{machine_room}"] ||= []) << machine_name
				# { floor => {room => [list,of,names] } }
				# floor_map['#{machine_floor}'] => {'#{machine_room}' => ['#{machine_name}']}
			end
		end
	}

	open(YAMLNAME, 'w') {|file|
		file.write(name_map.to_yaml)
		file.write(floor_map.to_yaml)
	}
	return YAMLNAME
end

def self.inventory
	@inventory ||= get_inventory
end
inventory
puts ">>> Loading complete. Carto initialized and ready..."
