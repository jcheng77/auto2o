require 'capistrano/passenger'

set :passenger_roles, :app                  # this is default
set :passenger_restart_runner, :sequence    # this is default
set :passenger_restart_wait, 5              # this is default
set :passenger_restart_limit, 2             # this is default

set :branch, :master

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{ubuntu@54.64.248.158}
role :web, %w{ubuntu@54.64.248.158}
role :db,  %w{ubuntu@54.64.248.158}
role :puma_nginx,  %w{ubuntu@54.64.248.158}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '54.64.248.158', user: 'ubuntu', roles: %w{web app}, my_property: :my_value


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
  keys: %w(~/.ssh/auto2o.pem),
}

set :rails_env, 'production'               # If the environment differs from the stage name
set :migration_role, 'db'                  # Defaults to 'db'
set :conditionally_migrate, false          # Defaults to false
set :assets_roles, [:web]                  # Defaults to [:web]
set :assets_prefix, 'assets'               # Defaults to 'assets' this should match config.assets.prefix in your rails config/application.rb