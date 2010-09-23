#!/usr/bin/env ruby

require 'net/http'
require 'rexml/document'
require 'singleton'

include REXML

puts ">>> Carto library loaded. Getting information..."

class Inventory
  include Singleton

  XML_PATH = LIB_ROOT + '/hosts/inventory.xml'
  YAML_PATH = LIB_ROOT + '/hosts/inventory.yaml'

  def inventory
    @inventory ||= get_inventory
  end

  private
  def get_inventory
    # If the YAML file already exists or the XML file is over a day old then
    # we should grab it again.
    unless FileTest.exist?(YAML_PATH) and File.mtime(XML_PATH) > (Time.now - 86400)
      puts ">>> Inventory out of date. Reacquiring data from the server..."
      
      # Check to see if the XML file already exists.
      unless FileTest.exist?(XML_PATH)
        
        # Download the file and store it at the XML_PATH.
        Net::HTTP.start('lcfg.inf.ed.ac.uk') { |http|
          resp = http.get('/profiles/inf.ed.ac.uk/inventory/XMLInventory/profile.xml')
          File.open(XML_PATH, 'w') { |file|
            file.write(resp.body)
          }
        }

        puts ">>> Reacquisition complete."
      end

      parse_xml File.new(PROFILENAME)
    end

    load_yaml
  end

  def load_yaml
    YAML::load_file YAML_PATH
  end

  def parse_xml xml_file
    document = Document.new xml_file
    output = Hash.new

    document.root.each_element('//node') do |machine| 
      location = machine.elements["location"].text

      unless location.nil?
        if location ~= /^AT/
          floor = location[3]
          room = location[5..-1]

          name = machine.attributes["name"].text

          output[name] = {:floor => floor,
                          :room => room} 
        end
      end
    end 

    File.open(YAML_PATH, 'w') do |file|
      file.write(output.to_yaml)
    end

    load_yaml
  end
end
