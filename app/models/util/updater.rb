module Util
  class Updater

     def self.run
      Admin::Project.project_list.each{ |proj_module| new.populate("Proj#{proj_module}") }
      self.populate_mesh_thesauri
      Util::DbManager.new.refresh_public_db
    end

    def self.populate_mesh_thesauri
      MeshArchive::Y2010MeshTerm.populate_from_file
      MeshArchive::Y2016MeshTerm.populate_from_file
      MeshArchive::Y2016MeshHeading.populate_from_file
    end

    def populate(proj_module)
      puts "Populating #{proj_module}..."
      proj_info = "#{proj_module}::ProjectInfo".constantize
      proj_info.load_project_tables
    end

    def image
      attachments.select{|a| a.is_image }.first
    end

    def data_def_attachment
      # There could be multiple attachments defined as Data Definitions. For now, just return first one.
      attachments.select{|a| a.description == 'Data Definitions' }.first
    end

    def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << column_names
        all.each do |uc|
          csv << uc.attributes.values_at(*column_names)
        end
      end
    end

  end
end
