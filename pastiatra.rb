require 'rubygems'
require 'sinatra'
require 'pastie'

require 'rack/contrib'
require 'rack/cache'
require 'rack_futurama'

use Rack::ETag
use Rack::Cache, :verbose => true,
                 :default_ttl => 60
use RackFuturama

configure do
  Pastie.number_of_pasties_to_list = 5
  # CONFIG = YAML.load('config.yml')
end

helpers do
  def current_time
    Time.now.rfc2822
  end
end

before do
  ua = request.env['HTTP_USER_AGENT']
  
  if ua && ua.match(/iPhone/)
    halt 401, "No mactards here..."
  end
end

get '/' do
  erb :index
end

get '/pasties' do
  pasties = Pastie.get_latest_pasties
  pasties.map! { |f| File.read(f) }
  
  content_type 'application/json'
  '[' + pasties.join(',') + ']'
end

get '/:id' do
    pastie = Pastie.get_pastie(params[:id])
    send_file pastie
end

post '/' do
  unless params[:pastie]
    halt 422, 'pastie is required'
  end
  
  id = Pastie.save_new_pastie(params[:pastie])
  redirect "/#{id}"
end

delete '/:id' do
    pastie = Pastie.get_pastie(params[:id])
    File.unlink(pastie)
end

error PastieNotFound do
  halt 404, request.env['sinatra.error'].message
end