CARTO_LIB = File.join(File.dirname(Pathname.new(__FILE__).realpath), '/carto')

Dir["CARTO_LIB/*"].each { |rb| require CARTO_LIB + rb }
