require 'rubygems'
require 'bundler/setup'
Bundler.require

GEOLOQI_REDIRECT_URI = 'http://127.0.0.1:9292'

enable :sessions

set :session_secret, '1234blahblah'

def geoloqi
  @geoloqi ||= Geoloqi::Session.new :auth => session[:geoloqi_auth],
                                    :config => {:client_id => 'YOUR OAUTH CLIENT ID',
                                                :client_secret => 'YOUR CLIENT SECRET',
                                                :use_hashie_mash => true}
end

after do
  session[:geoloqi_auth] = @geoloqi.auth
end

get '/?' do
  geoloqi.get_auth(params[:code], GEOLOQI_REDIRECT_URI) if params[:code] && !geoloqi.access_token?
  redirect geoloqi.authorize_url(GEOLOQI_REDIRECT_URI) unless geoloqi.access_token?

  username = geoloqi.get('account/username')['username']
  "You have successfully logged in as #{username}!"
end