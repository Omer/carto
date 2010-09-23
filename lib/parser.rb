#!/usr/bin/env ruby

require 'net/http'
require 'rexml/document'
include REXML

PROFILENAME = APP_ROOT + '/hosts/inventory.xml'
YAMLNAME = APP_ROOT + '/hosts/inventory.yaml'

puts ">>> Carto library loaded. Getting information..."
def self.get_inventory
	unless FileTest.exist?(YAMLNAME) and File.mtime(PROFILENAME) > (Time.now - 86400)
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
	end
	puts ">>> Inventory loaded. <<<"
	return YAMLNAME
end

def self.parse_me(invo)
	output = "---\n"
	invo.elements.each('inventory/node') { |element| 
		machine_loc = element.elements["location"].text
		unless machine_loc.nil?
			if machine_loc[0..1] == "AT"
				machine_floor = machine_loc[3,1]
				machine_room = machine_loc[5..-1]
				machine_name = element.attributes["name"]
				output << "-\tname:\t#{machine_name}\n\tfloor:\t#{machine_floor}\n\troom:\t#{machine_room}\n"
			end
		end
	}
	open(YAMLNAME, 'w') {|file|
		file.write(output)
	}
	return YAMLNAME
end

def self.inventory
	@inventory ||= get_inventory
end
inventory
puts ">>> Loading complete. Carto initialized and ready..."
