# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}

set :deploy_to, '/var/capistrano/master'
set :branch, 'master'

namespace :deploy do	
	before :starting, :vaihang do
		on roles(:app) do
  			ENV['SERVER_TIMESTEMP'] = Time.now.to_i.to_s		
			print "----------- GET TIMESTEMP ON PHP SERVER ------------\n"
			print "SERVER_TIMESTEMP: #{ENV['SERVER_TIMESTEMP']}\n"
			print "----------- GET TIMESTEMP ON PHP SERVER ------------\n"		
		end
  	end

	before :"symlink:release", :run_composer do
		on roles(:app) do
			print "--------- symlink .env file to release directory ------"	
			execute "cp /var/capistrano/.env #{release_path}/.env"
			print "SERVER_TIMESTEMP: #{ENV['SERVER_TIMESTEMP']}\n"
			print "----------- RUN COMPOSER INSTALL -----------\n"			
			execute "cd #{release_path}; composer install --no-dev"			
			print "----------- END COMPOSER INSTALL -----------\n"
			execute "chmod 0777 #{release_path}/storage"
		end
	end

	after :finishing, :notify do
		on roles(:app) do
		print "----------- SEND NOTIFICATION TO CHATWORK -----------\n"
		# system("ln -s /var/capistrano/.env #{release_path}/.env")
		end
	end

end

server 'php', user: 'root', port: 22, password: '123123', roles: %w{web app db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server "php",
#   user: "root",
#   roles: %w{web app},
#   ssh_options: {
#     user: "root", # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(password),
#     password: "123123"
#   }