require APP_ROOT + '/lib/carto/parser'

module Inventory
  include Parser
  
  @inventory ||= Parser.get_inventory
    
  def self.find_by(symbol)
    (class << self; self; end).instance_eval do
      unless symbol == :host
        define_method("find_by_#{symbol}") do |number|
          @inventory.map { |hostname, details| hostname if details["#{symbol}"] == number }.compact
        end
      else
        define_method("find_by_host") { |hostname| @inventory[hostname] }
      end
    end
  end

  def self.get_neighbours_for(hostname)
  	find_by_floor(find_by_host(hostname)['floor']) - [hostname] 
  end
  
  [:room, :floor, :host].each { |symbol| find_by(symbol) }
end