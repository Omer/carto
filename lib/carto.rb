require 'pathname'

APP_ROOT = File.join(File.dirname(Pathname.new(__FILE__).realpath),'/..')

require APP_ROOT + '/lib/carto/inventory'
