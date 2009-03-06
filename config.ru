require 'pastiatra'

disable :run
set :environment, :production
run Sinatra::Application
