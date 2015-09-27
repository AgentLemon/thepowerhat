set :application, 'thepowerhat'
set :repo_url, 'git@github.com:AgentLemon/thepowerhat.git'
set :branch, 'master'

set :deploy_to, '/opt/thepowerhat'

set :scm, :git
set :use_sudo, true

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :default_env, { path: "$PATH" }
set :rails_env, "production"
set :keep_releases, 5

set :linked_dirs, (fetch(:linked_dirs) || []) + %w{bin log tmp/pids tmp/cache tmp/sockets uploads dumps public/avatars}

namespace :deploy do

  desc "Restart the Thin processes"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, "exec thin -d -P /tmp/pids/thin.pid -e production stop"
        execute :bundle, "exec thin -d -P /tmp/pids/thin.pid -e production start"
        execute "service nginx restart"

        execute :bundle, "exec whenever -w"
      end
    end
  end

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #
  #   end
  # end

  after :finishing, 'deploy:cleanup'

end
