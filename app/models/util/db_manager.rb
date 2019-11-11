require 'open3'
module Util
  class DbManager

    def refresh_public_db
      File.delete(dump_file_name) if File.exist?(dump_file_name)
      run_command(dump)
      run_command(restore('aact'))
      run_command(restore('aact_alt'))
      grant_privs
    end

    def dump
      schema_snippet = Admin::Project.schema_name_array.join(' --schema mesh_archive --schema ')
      "pg_dump #{AACT::Application::AACT_PROJ_DATABASE_URL} -v -h localhost -p 5432 -U #{AACT::Application::AACT_DB_SUPER_USERNAME} --no-password --clean --schema #{schema_snippet} -b -c -C -Fc -f #{dump_file_name}"
    end

    def restore(database_name)
      "pg_restore -c -j 5 -v -h #{AACT::Application::AACT_PUBLIC_HOSTNAME} -p 5432 -U #{AACT::Application::AACT_DB_SUPER_USERNAME} -d #{database_name}  #{dump_file_name}"
    end

    def grant_privs
      con=ActiveRecord::Base.establish_connection(AACT::Application::AACT_PUBLIC_DATABASE_URL).connection
      con.execute("GRANT USAGE ON SCHEMA ctgov to read_only;")
      con.execute("GRANT USAGE ON SCHEMA mesh_archive to read_only;")
      con.execute("GRANT SELECT ON ALL TABLES IN SCHEMA ctgov TO read_only;")
      con.execute("GRANT SELECT ON ALL TABLES IN SCHEMA mesh_archive TO read_only;")
      Admin::Project.schema_name_array.each {|schema_name|
        con.execute("GRANT USAGE ON SCHEMA #{schema_name} to read_only;")
        con.execute("GRANT SELECT ON ALL TABLES IN SCHEMA #{schema_name} TO read_only;")
      }
      con.reset!

      con=ActiveRecord::Base.establish_connection(AACT::Application::AACT_ALT_PUBLIC_DATABASE_URL).connection
      con.execute("GRANT USAGE ON SCHEMA ctgov to read_only;")
      con.execute("GRANT USAGE ON SCHEMA mesh_archive to read_only;")
      con.execute("GRANT SELECT ON ALL TABLES IN SCHEMA ctgov TO read_only;")
      con.execute("GRANT SELECT ON ALL TABLES IN SCHEMA mesh_archive TO read_only;")
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
      "#{AACT::Application::AACT_STATIC_FILE_DIR}/other/project.dmp"
    end

  end
end

