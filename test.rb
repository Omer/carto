#!/usr/bin/env ruby

require 'rubygems'
require 'carto'

add_machine("test", "north", "5", "A0")
cleanup

@coll.drop
