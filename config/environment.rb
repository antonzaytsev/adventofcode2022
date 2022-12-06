require 'rubygems'
require 'bundler'
Bundler.setup(:default)

Dir['app/*.rb'].each do | file|
  require "./#{file.sub('.rb', '')}"
end
