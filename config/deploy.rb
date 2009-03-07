set :application, 'pastiatra'
set :user, "root"
set :use_sudo, false

set :scm, :git
set :repository, "file:///Users/rubenfonseca/today"

set :deploy_to, '/var/www'
set :deploy_via, :copy

role :app, "host1"

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  task :stop, :roles => :app do
    # no-op
  end
  
  task :restart, :roles => :app do
    deploy.stop
    deploy.start
  end
end