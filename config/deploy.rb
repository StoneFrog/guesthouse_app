# config valid only for current version of Capistrano
lock '3.4.0'

#


# General

#default_run_options[:pty] = true

set :user, "deploy"
set :application, 'guesthouse_app'
set :deploy_to, '/home/deploy/www/guesthouse_app'
set :pty, true
#set :stages ["staging", "production"]
#set :default_stage, "staging"
set :rvm1_ruby_version, "ruby-2.2.3"
set :passenger_restart_with_touch, true
# Git
set :scm, :git
set :repo_url, 'https://github.com/Toquamer/guesthouse_app.git'
set :branch, "master"

# Server

# Symlinking
set :linked_files, %w{ config/database.yml }

# Passenger
namespace :deploy do 
  task :start do ; end
  task :stop do ; end
  task :restart do 
    on roles(:app) do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end
  after :finishing, "deploy:cleanup"
end



=begin
namespace :deploy do
  task :symlink_db, :roles =>need to wrap your task body in a on ... do ... end block, e.g.  :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml" # This file is not included repository, so we will create a symlink 
  end
  task :symlink_secret_token, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb" # This file is not included repository, so we will create a symlink 
  end
end
=end
#before 'deploy:assets:precompile', 'deploy:symlink_db' # callback: run this task before deploy:assets:precompile
#before 'deploy:assets:precompile', 'deploy:symlink_secret_token' # # callback: run this task before deploy:assets:precompile
#after "deploy", "deploy:cleanup" # delete old releases

#set :rails_env, "production"
#set :deploy_via, :copy
