require 'sinatra'
require 'sinatra/geoloqi'
require 'yaml'

configure do
  $config = YAML.load_file './config.yml'
  $config.each do |key,value|
    send :set, key.to_sym, value
  end
end

before do
  require_geoloqi_login
end

get '/?' do
  username = geoloqi.get('account/username')['username']
  "You have successfully logged in as #{username}!"
end