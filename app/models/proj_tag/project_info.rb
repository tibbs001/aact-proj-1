module ProjTag
  class ProjectInfo < ProjectInfoTemplate

    def self.meta_info
      #  Required:  name, schema_name & migration_file_name
      { name:                 'Aggregated Set of Tagged MeSH Terms',
        schema_name:          'proj_tag',
        brief_summary:        "A number of clinicians have reviewed & categorized MeSH terms by clinical domain. We have aggregated this categorization information so that others can benefit from this body of work. Tables that map MeSH terms to general categories are available to query.",
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
        {
          description: '2017 Free Text Terms Tagged by Clinical Domain',
          file_name: "#{Rails.public_path}/incoming/2017_free_tagged_terms.xlsx",
          file_type: 'application/vnd.openxmlformats-officedocument.spreads'
        },
        {
          description: '2017 MeSH Terms Tagged by Clinical Domain',
          file_name: "#{Rails.public_path}/incoming/2017_mesh_tagged_terms.xlsx",
          file_type: 'application/vnd.openxmlformats-officedocument.spreads'
        },
      ]
    end

    def self.populate
      ProjTag::TaggedTerm.populate
    end

  end
end
