module ProjTag
  class ProjectInfo

    def self.meta_info
      #  Required:  name, schema_name & migration_file_name
      { name:                 'Aggregated Set of Tagged MeSH Terms',
        schema_name:          'proj_tag',
        brief_summary:        "Between 2010 and 2013, a number of clinicians reviewed & categorized the 2010 MeSH terms and also free text terms by clinical domain. We loaded this categorization information into a table so others can benefit from the work performed by these clinicians. The proj_tag.tagged_terms table is essentially an index that maps MeSH terms to clinical domains. This table can be included in queries against the CinicalTrials.gov data (found in the ctgov schema) to retrieve a set of studies related the a given clinical domain. The clinical domains into which terms have been categorized are: Cardiology, Immuno_Rheumatology, Infectious_Diseases, Psych_General, Oncology, Otolaryngology, Pulmonary_Medicine & Nephrology.",
        migration_file_name:  Rails.root.join('db','migrate','20180719000122_create_proj_tag_tables.rb').to_s,
        organizations:        'Duke Clinical Research Institute',
        data_available:       true,
        start_date:           Date.strptime('27/09/2010', '%d/%m/%Y'),
        year:                 2010,
      }
    end

    def self.publications
      []
    end

    def self.datasets
      []
    end

    def self.attachments
      [
        {
          description: '2010 Free Text Terms Tagged by Clinical Domain',
          file_name: "#{Rails.public_path}/incoming/2010_free_tagged_terms.xlsx",
          file_type: 'application/vnd.openxmlformats-officedocument.spreads'
        },
        {
          description: '2010 MeSH Terms Tagged by Clinical Domain',
          file_name: "#{Rails.public_path}/incoming/2010_mesh_tagged_terms.xlsx",
          file_type: 'application/vnd.openxmlformats-officedocument.spreads'
        },
        {
          description: '2016 Free Text Terms Tagged by Clinical Domain',
          file_name: "#{Rails.public_path}/incoming/2016_free_tagged_terms.xlsx",
          file_type: 'application/vnd.openxmlformats-officedocument.spreads'
        },
        {
          description: '2016 MeSH Terms Tagged by Clinical Domain',
          file_name: "#{Rails.public_path}/incoming/2016_mesh_tagged_terms.xlsx",
          file_type: 'application/vnd.openxmlformats-officedocument.spreads'
        },
      ]
    end

    def self.load_project_tables
      ProjTag::TaggedTerm.populate
    end

  end
end
