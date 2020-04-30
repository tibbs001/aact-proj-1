module ProjCovid
  class ProjectInfo

    def self.meta_info
      #  Required:  name, schema_name & migration_file_name
      { name:                 'COVID-19 Related Studies',
        schema_name:          'proj_covid',
        brief_summary:        "Current Set of COVID-19-related Studies",
        migration_file_name:  Rails.root.join('db','migrate','20200424000122_create_proj_covid_tables.rb').to_s,
        organizations:        'Duke Clinical Research Institute',
        data_available:       true,
        start_date:           Date.strptime('01/01/2020', '%d/%m/%Y'),
        year:                 2020,
      }
    end

    def self.publications
      []
    end

    def self.datasets
      []
    end

    def self.attachments
      []
    end

    def self.faqs
      []
    end

    def self.populate
      ProjCovid::CovidStudyId.populate
      ProjCovid::CovidStudy.populate
    end

  end
end
