class ProjectInfoTemplate

    def self.meta_info
      #  Required:  name, schema_name & migration_file_name
      { name:                '',
        schema_name:         '',
        migration_file_name: '',
        investigators:       '',
        organizations:       '',
        contact_info:        '',
        contact_url:         '',
        data_available:      false,
        aact_version:        '',
        start_date:          Date.strptime('27/09/2010', '%d/%m/%Y'),
        year:                2012,
        url:                 '',
        email:               '',
        brief_summary:       '',
        description:         '',
        study_selection_criteria: '',
      }
    end

    def self.faqs
      # {
      #   question: '',
      #   answer: ''
      #   citation: '',
      #   url: '',
      # }
      []
    end

    def self.publications
      # {
      #   journal_name: '',
      #   publication_date: Date.strptime('05/02/2012', '%d/%m/%Y'),
      #   pub_type: 'AcademicArticle',
      #   pmid: '',
      #   pmcid: '',
      #   doi: '',
      #   title: '',
      #   url: '',
      #   citation: ''
      # }
      []
    end

    def self.attachments
      # {
      #   description: '',
      #   file_name: '',
      #   file_type: 'application/vnd.openxmlformats-officedocument.spreads'
      # }
      []
    end

    def self.datasets
      # {
      #   dataset_type: '',
      #   schema_name: '',
      #   name: '',
      #   file_name: "#{Rails.public_path}/attachments/<name>.xlsx",
      #   file_type: 'application/vnd.openxmlformats-officedocument.spreads',
      #   description:  "",
      #   source: ""
      # }
      []
    end

    def self.populate
      #ProjXXX::TaggedTerm.populate
    end

end
