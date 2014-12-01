require 'capistrano/puma'
# require 'capistrano/puma/workers' #if you want to control the workers (in cluster mode)
# require 'capistrano/puma/jungle'  #if you need the jungle tasks
# require 'capistrano/puma/monit'   #if you need the monit tasks
require 'capistrano/puma/nginx'   #if you want to upload a nginx site template

set :branch, :develop


##### For Puma
# Configurable options, shown here with defaults: Please note the configuration options below are not required unless you are trying to override a default setting, for instance if you are deploying on a host on which you do not have sudo or root privileges and you need to restrict the path. These settings go in the deploy.rb file.
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 16]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, false
set :puma_preload_app, true


# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{ubuntu@54.68.52.232}
role :web, %w{ubuntu@54.68.52.232}
role :db,  %w{ubuntu@54.68.52.232}
role :puma_nginx,  %w{ubuntu@54.68.52.232}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '54.68.52.232', user: 'ubuntu', roles: %w{web app}, my_property: :my_value


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }

set :ssh_options, {
  keys: %w(~/.ssh/ubuntu.pem),
}

set :rails_env, 'staging'                  # If the environment differs from the stage name
set :migration_role, 'db'                  # Defaults to 'db'
set :conditionally_migrate, false          # Defaults to false
set :assets_roles, [:web]                  # Defaults to [:web]
set :assets_prefix, 'assets'               # Defaults to 'assets' this should match config.assets.prefix in your rails config/application.rb

set :puma_env, 'staging'