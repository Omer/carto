#!/usr/bin/env ruby

require 'pathname'
require 'net/http'
require 'rexml/document'
include REXML

APP_ROOT = File.join(File.dirname(Pathname.new(__FILE__).realpath),'/..')
LIB_ROOT = APP_ROOT + '/lib'

PROFILENAME = APP_ROOT + '/hosts/inventory.xml'

p "Carto library loaded. Getting information..."
def self.get_inventory
	unless FileTest.exist?(PROFILENAME) and File.mtime(PROFILENAME) > (Time.now - 86400)
		p "Inventory out of date. Reacquiring data from the server..."
		Net::HTTP.start('lcfg.inf.ed.ac.uk') { |http|
			resp = http.get('/profiles/inf.ed.ac.uk/inventory/XMLInventory/profile.xml')
			open(PROFILENAME, 'w') { |file|
				file.write(resp.body)
			}
		}
	end
	p "Reacquisition complete."
	return Document.new(File.new(PROFILENAME))
end

def self.inventory
	@inventory ||= get_inventory
end

puts inventory()
