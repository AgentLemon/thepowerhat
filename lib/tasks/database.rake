namespace :database do

  task :dump => :environment do
    exec "pg_dump -d #{Rails.configuration.database_configuration[Rails.env]["database"]} -f dumps/#{Date.today}.sql"
  end

end
