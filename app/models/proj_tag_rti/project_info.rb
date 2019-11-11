module ProjTagRti
  class ProjectInfo < ProjectInfoTemplate

    def self.meta_info
      { name:                 ' Respiratory tract infection clinical trials from 2007 to 2012. A systematic review of clinicaltrials. gov.',
        schema_name:          'proj_tag_rti',
        brief_summary:        "",
        investigators:        'Ruopp M, Chiswell K, Thaden JT, Merchant K, Tsalik EL.',
        migration_file_name:  Rails.root.join('db','migrate','20190306000122_create_proj_tag_pvd_tables.rb').to_s,
        organizations:        'Duke Clinical Research Institute',
        data_available:       true,
        aact_version:         'September 27, 2010',
        start_date:           Date.strptime('27/09/2010', '%d/%m/%Y'),
        year:                 2013,
        study_selection_criteria: ''
      }
    end

    def self.publications
      [{
        journal_name:     'Annals of the American Thoracic Society.',
        publication_date: Date.strptime('05/01/2014', '%d/%m/%Y'),
        pub_type:         'AcademicArticle',
        title:            ' Respiratory tract infection clinical trials from 2007 to 2012. A systematic review of clinicaltrials. gov.',
        url:              'https://www.ncbi.nlm.nih.gov/pubmed/26360527',
        pmid:             '26360527',
        pmcid:            '',
        doi:              '10.1513/AnnalsATS.201505-291OC',
        citation:         'Ruopp M, Chiswell K, Thaden JT, Merchant K, Tsalik EL. Respiratory tract infection clinical trials from 2007 to 2012. A systematic review of clinicaltrials. gov. Annals of the American Thoracic Society. 2015 Dec;12(12):1852-63.'
      }]
    end

    def self.datasets
      [
        {
          dataset_type: 'terms',
          schema_name:  'proj_tag_rti',
          table_name:   'tagged_terms',
          name:         'Respiratory Tract Infection Terms (MeSH & Free Text)',
          file_name:    "#{Rails.public_path}/attachments/proj_tag_rti_terms.xlsx",
          file_type:    'application/vnd.openxmlformats-officedocument.spreads',
          description:  'xxxxx unique MeSH condition terms & xxx unique free text condition terms tagged for respiratory tract infection',
          source:       'The MeSH terms are from the 2010 MeSH thesaurus, terms in branches C, E, F, G. The free text terms are those  that occurred in AACT(2010).Conditions field with frequency >=5 among interventional studies registered on or after Oct 1, 2007, and that did not exist in MeSH thesaurus.'
        },
        {
          dataset_type: 'study list',
          schema_name:  'proj_tag_pvd',
          table_name:   'analyzed_studies',
          name:         'Analyzed Studies',
          file_name:    "#{Rails.public_path}/attachments/proj_tag_rti_studies.xlsx",
          file_type:    'application/vnd.openxmlformats-officedocument.spreads',
          source:       "From AACT(2010), subset on 40,970 interventional studies registered on or after October 1, 2007. Searched for studies with respiratory tract infection-specific terms in AACT(2010).Conditions, OR AACT(2010).Keywords, OR AACT(2010).MeSH_Trees (where MeSH_Type='condition). Investigators then reviewed the resulting list of studies and identified the final cohort of xxxxx respiratory tract infection trials reported in the manuscript."
        },
      ]
    end

    def self.attachments
      []
    end

    def self.populate
      #ProjTagPvd::AnalyzedStudy.populate
    end

  end
end
