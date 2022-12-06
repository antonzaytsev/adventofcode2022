require 'rubygems'
require 'bundler'
Bundler.require(:default)

Dir['app/*.rb'].each do | file|
  require "./#{file.sub('.rb', '')}"
end
