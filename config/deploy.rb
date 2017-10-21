# config valid only for current version of Capistrano
lock "3.9.1"

server "82.165.71.211", port: 22, roles: [:web, :app, :db], primary: true

set :application, "cca"
set :repo_url, "git@github.com:laurentqro/cca.git"
set :user,            'deployer'
set :puma_threads,    [4, 16]
set :puma_workers,    0

set :pty, true # default is false
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
set :keep_releases, 5

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml.key"

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads'

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :airbrussh
# set :log_level,     :debug
# set :keep_releases, 5
# set :default_env,   { path: "/opt/ruby/bin:$PATH" }
# You can configure the Airbrussh format using :format_options.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto
# Default value for local_user is ENV['USER']
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

namespace :puma do
  desc 'Create Directories for Puma pids and socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

# ps aux | grep puma    # Get puma pid
# # kill -s SIGUSR2 pid   # Restart puma
# # kill -s SIGTERM pid   # Stop puma
