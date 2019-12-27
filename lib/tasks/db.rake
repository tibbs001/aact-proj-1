#Rake::Task["db:drop"].clear
#Rake::Task["db:migrate"].clear

namespace :db do

  desc 'Clear out Project tables in aact_admin & then drop projects database'

  task create: [:environment] do
    puts "aact_proj db:  set search_path ..."
    con=ActiveRecord::Base.establish_connection("postgres://tibbs001@localhost:5432/aact_proj").connection
    con.execute("alter role #{AactProj::Application::AACT_DB_SUPER_USERNAME} in database aact_proj set search_path = ctgov, mesh_archive, #{Admin::Project.schema_name_list}, public;")
    con.execute("alter role #{AactProj::Application::WIKI_DB_SUPER_USERNAME} in database aact_proj set search_path = ctgov, mesh_archive, #{Admin::Project.schema_name_list}, public;")
    con.reset!

    Rake::Task["db:create"].invoke
  end

  task migrate: [:environment] do
    Rake::Task["db:migrate"].invoke
    # The only way to access these schemas should be with the read-only role.
    # When users register (before they confirm their email), they are considered 'public'.
    # Don't let these unconfirmed users access these schemas until they confirm.
    # When they confirm, they become members of 'ready-only', then they have access.
    con=ActiveRecord::Base.establish_connection("postgres://tibbs001@localhost:5432/aact_proj").connection
    con.execute("REVOKE SELECT ON ALL TABLES IN SCHEMA mesh_archive FROM public;")
    con.execute("REVOKE ALL ON SCHEMA mesh_archive FROM public;")
    Admin::Project.schema_name_array.each{ |schema_name|
      con.execute("REVOKE SELECT ON ALL TABLES IN SCHEMA #{schema_name} FROM public;")
      con.execute("REVOKE ALL ON SCHEMA #{schema_name} FROM public;")
    }
   con.reset!
  end

end
