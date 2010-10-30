require 'yaml'
require 'net/http'
require 'rexml/document'
include REXML

PROFILENAME = APP_ROOT + '/hosts/inventory.xml'
YAMLNAME = APP_ROOT + '/hosts/inventory.yaml'

module Parser
  class << self
    def get_inventory
    	unless FileTest.exist?(YAMLNAME) and File.mtime(YAMLNAME) > (Time.now - 86400)
        if `ping -t 5 lcfg.inf.ed.ac.uk`
          puts ">>> Inventory out of date. Reacquiring data from the server..."
          
    			unless FileTest.exist?(PROFILENAME)
    				Net::HTTP.start('lcfg.inf.ed.ac.uk') do |http|
    					resp = http.get('/profiles/inf.ed.ac.uk/inventory/XMLInventory/profile.xml')
    					open(PROFILENAME, 'w') { |file| file.write(resp.body) }
    				end
            puts ">>> Reacquisition complete."
    			end
    			
    			parse_me( Document.new(File.new(PROFILENAME)) )
        else
          puts "No net connection. Falling back to saved file." 
        end
      else
        YAML::load(File.open(YAMLNAME)) 
    	end
    end

    def parse_me(invo)
    	name_map = Hash.new

    	invo.elements.each('inventory/node') do |element| 
    		machine_loc = element.elements["location"].text
    		unless machine_loc.nil?
    		  if machine_loc.match %r{^AT-(.*)\.(.*)}
    			  name_map[element.attributes["name"]] = { 'floor' => $1, 'room' => $2 } 
  			  end
    		end
    	end

    	open(YAMLNAME, 'w') { |file| file.write(name_map.to_yaml) }
    	
    	name_map
    end
    
    def flush_cache
      `rm #{YAMLNAME}`
    end
  end
end
