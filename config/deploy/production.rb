set :stage, :production

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
#role :app, %w{root@thepowerhat.tk}
#role :web, %w{root@thepowerhat.tk}
#role :db,  %w{root@thepowerhat.tk}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server 'thepowerhat.com', user: 'root', roles: %w{web app db}

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
server 'thepowerhat.com',
   user: 'root',
   roles: %w{web app db},
   ssh_options: {
     forward_agent: true,
     auth_methods: %w(publickey password),
   }
# setting per server overrides global ssh_options

# fetch(:default_env).merge!(rails_env: :production)
