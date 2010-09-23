#!/usr/bin/env ruby

require 'pathname'
require 'net/http'
require 'rexml/document'
include REXML

APP_ROOT = File.join(File.dirname(Pathname.new(__FILE__).realpath),'/..')
LIB_ROOT = APP_ROOT + '/lib'

PROFILENAME = APP_ROOT + '/hosts/inventory.xml'

puts ">>> Carto library loaded. Getting information..."
def self.get_inventory
	unless FileTest.exist?(PROFILENAME) and File.mtime(PROFILENAME) > (Time.now - 86400)
		puts ">>> Inventory out of date. Reacquiring data from the server..."
		Net::HTTP.start('lcfg.inf.ed.ac.uk') { |http|
			resp = http.get('/profiles/inf.ed.ac.uk/inventory/XMLInventory/profile.xml')
			open(PROFILENAME, 'w') { |file|
				file.write(resp.body)
			}
		}
		puts ">>> Reacquisition complete."
	end
	puts ">>> Inventory loaded. <<<"
	return Document.new(File.new(PROFILENAME))
end

def self.inventory
	@inventory ||= get_inventory
end

inventory()
@inventory.elements.each('inventory/node') { |element| 
	machine_loc = element.elements["location"].text
	unless machine_loc.nil?
		if machine_loc[0..1] == "AT"
			puts "#{element.attributes["name"]}:#{machine_loc}"
		end
	end
	}

