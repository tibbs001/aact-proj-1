#Rake::Task["db:drop"].clear
#Rake::Task["db:migrate"].clear

namespace :db do

  desc 'Clear out Project tables in aact_admin & then drop projects database'
  task drop: [:environment] do
    puts "aact_admin db:  Clear out project tables..."
    con=ActiveRecord::Base.establish_connection(ENV['AACT_ADMIN_DATABASE_URL']).connection
    con.execute("TRUNCATE TABLE projects;")
    con.execute("TRUNCATE TABLE attachments;")
    con.execute("TRUNCATE TABLE datasets;")
    con.execute("TRUNCATE TABLE publications;")
    con.reset!
    #Rake::Task["db:drop"].invoke
  end

  task create: [:environment] do
    puts "aact_proj db:  set search_path ..."
    con=ActiveRecord::Base.establish_connection(ENV['AACT_PROJ_DATABASE_URL']).connection
    con.execute("alter role #{ENV['AACT_PROJ_DB_SUPER_USERNAME']} in database #{ENV['AACT_PROJ_DATABASE']} set search_path = ctgov, mesh_archive, #{Admin::Project.schema_name_list}, public;")
    con.reset!

    con=ActiveRecord::Base.establish_connection(ENV['AACT_PUBLIC_DATABASE_URL']).connection
    con.execute("alter role read_only in database #{ENV['AACT_PUBLIC_DATABASE_NAME']} set search_path = ctgov, mesh_archive, #{Admin::Project.schema_name_list}, public;")
    con.execute("alter role read_only in database #{ENV['AACT_PUBLIC_DATABASE_NAME']}_alt set search_path = ctgov, mesh_archive, #{Admin::Project.schema_name_list}, public;")
    con.reset!
    Rake::Task["db:create"].invoke
  end

  task migrate: [:environment] do
    Rake::Task["db:migrate"].invoke
    # The only way to access these schemas should be with the read-only role.
    # When users register (before they confirm their email), they are considered 'public'.
    # Don't let these unconfirmed users access these schemas until they confirm.
    # When they confirm, they become members of 'ready-only', then they have access.
    con=ActiveRecord::Base.establish_connection(ENV['AACT_PROJ_DATABASE_URL']).connection
    con.execute("REVOKE SELECT ON ALL TABLES IN SCHEMA mesh_archive FROM public;")
    con.execute("REVOKE ALL ON SCHEMA mesh_archive FROM public;")
    Admin::Project.schema_name_array.each{ |schema_name|
      con.execute("REVOKE SELECT ON ALL TABLES IN SCHEMA #{schema_name} FROM public;")
      con.execute("REVOKE ALL ON SCHEMA #{schema_name} FROM public;")
    }
   con.reset!
  end

  def db_name
    AactProj::Application::AACT_PROJ_DB_NAME
  end

  def wiki_superuser_name
    AactProj::Application::AACT_DB_SUPER_USERNAME
  end

  def superuser_name
    AactProj::Application::AACT_DB_SUPER_USERNAME
  end

end
