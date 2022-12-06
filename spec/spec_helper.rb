require 'rspec'
require 'pry'

Dir['app/*.rb'].each do | file|
  require "./#{file.sub('.rb', '')}"
end
