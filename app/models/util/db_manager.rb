require 'open3'
module Util
  class DbManager

    def refresh_public_db
      File.delete(dump_file_name) if File.exist?(dump_file_name)
      run_command(dump)
      run_command(restore('open_trials'))
      grant_privs
    end

    def dump
      schema_snippet = Admin::Project.schema_name_array.join(' --schema mesh_archive --schema ')
      cmd = "pg_dump aact_proj -v -h localhost -p 5432 -U #{AactProj::Application::WIKI_DB_SUPER_USERNAME} --no-password --clean --schema #{schema_snippet} -b -c -C -Fc -f #{dump_file_name}"
      puts cmd
      return cmd
    end

    def restore(database_name)
      cmd = "pg_restore -c -j 5 -v -h #{AactProj::Application::AACT_PUBLIC_HOSTNAME} -p 5432 -U #{AactProj::Application::AACT_DB_SUPER_USERNAME} -d #{database_name}  #{dump_file_name}"
      puts cmd
      return cmd
    end

    def grant_privs
      con=ActiveRecord::Base.establish_connection(AactProj::Application::AACT_PUBLIC_DATABASE_URL).connection
      con.execute("alter role  #{AactProj::Application::WIKI_DB_SUPER_USERNAME} in database open_trials set search_path = ctgov, support, #{Admin::Project.schema_name_list}, public;")
      con.execute("alter role  #{AactProj::Application::AACT_DB_SUPER_USERNAME} in database open_trials set search_path = ctgov, support, #{Admin::Project.schema_name_list}, public;")
      con.execute("GRANT USAGE ON SCHEMA ctgov to read_only;")
      con.execute("GRANT SELECT ON ALL TABLES IN SCHEMA ctgov TO read_only;")
      Admin::Project.schema_name_array.each {|schema_name|
        con.execute("GRANT USAGE ON SCHEMA #{schema_name} to read_only;")
        con.execute("GRANT SELECT ON ALL TABLES IN SCHEMA #{schema_name} TO read_only;")
      }
      con.reset!

      con=ActiveRecord::Base.establish_connection(AactProj::Application::AACT_PUBLIC_DATABASE_URL).connection
      con.execute("GRANT USAGE ON SCHEMA ctgov to read_only;")
      con.execute("GRANT SELECT ON ALL TABLES IN SCHEMA ctgov TO read_only;")
      Admin::Project.schema_name_array.each {|schema_name|
        con.execute("GRANT USAGE ON SCHEMA #{schema_name} to read_only;")
        con.execute("GRANT SELECT ON ALL TABLES IN SCHEMA #{schema_name} TO read_only;")
      }
      con.reset!
    end

    def run_command(cmd)
      stdout, stderr, status = Open3.capture3(cmd)
      if status.exitstatus != 0
        success_code=false
      end
    end

    def dump_file_name
      '/aact-files/other/project.dmp'
    end

  end
end

