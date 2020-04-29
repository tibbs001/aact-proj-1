module Admin
  class Project < AdminBase
    has_many :attachments
    has_many :datasets
    has_many :faqs
    has_many :publications

    def self.project_list
      # A list of all project modules currently in AACT.
      # Each module (in app/models) encapsulates all info about the project.
      # Tag must get created before all the other Tag-related projects.
      [ 'Covid', 'ResultsReporting', 'CdekStandardOrgs', 'TagNephrology', 'TagStudyCharacteristics' ]
    end

    def self.schema_name_array
      project_list.map{|p| "Proj#{p}".underscore }
    end

    def self.schema_name_list
      schema_name_array.join(', ')
    end

  end
end
