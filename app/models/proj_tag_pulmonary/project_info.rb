module ProjTagPulmonary
  class ProjectInfo < ProjectInfoTemplate

    def self.meta_info
      { name:                 'Using ClinicalTrials. gov to understand the state of clinical research in pulmonary, critical care, and sleep medicine',
        schema_name:          'proj_tag_pulmonary',
        brief_summary:        "",
        investigators:        'Todd JL, White KR, Chiswell K, Tasneem A, Palmer SM.',
        migration_file_name:  Rails.root.join('db','migrate','20181104000122_create_proj_tag_pulmonary_tables.rb').to_s,
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
        title:            'Using ClinicalTrials. gov to understand the state of clinical research in pulmonary, critical care, and sleep medicine.',
        url:              'https://www.ncbi.nlm.nih.gov/pubmed/23987571',
        pmid:             '23987571',
        pmcid:            'PMC3882749',
        doi:              '10.1513/AnnalsATS.201305-111OC',
        citation:         'Todd JL, White KR, Chiswell K, Tasneem A, Palmer SM. Using ClinicalTrials. gov to understand the state of clinical research in pulmonary, critical care, and sleep medicine. Annals of the American Thoracic Society. 2013 Oct;10(5):411-7.'
      }]
    end

    def self.datasets
      [
        {
          dataset_type: 'terms',
          schema_name:  'proj_tag_pulmonary',
          table_name:   'tagged_terms',
          name:         'Pulmonary Terms (MeSH & Free Text)',
          file_name:    "#{Rails.public_path}/attachments/proj_tag_pulmonary_terms.xlsx",
          file_type:    'application/vnd.openxmlformats-officedocument.spreads',
          description:  '582 unique MeSH condition terms & 45 unique free text condition terms tagged for pulmonary',
          source:       'The MeSH terms are from the 2010 MeSH thesaurus, terms in branches C, E, F, G. The free text terms are those  that occurred in AACT(2010).Conditions field with frequency >=5 among interventional studies registered on or after Oct 1, 2007, and that did not exist in MeSH thesaurus.'
        },
        {
          dataset_type: 'study list',
          schema_name:  'proj_tag_pulmonary',
          table_name:   'analyzed_studies',
          name:         'Analyzed Studies',
          file_name:    "#{Rails.public_path}/attachments/proj_tag_pulmonary_studies.xlsx",
          file_type:    'application/vnd.openxmlformats-officedocument.spreads',
          source:       "From AACT(2010), subset on 40,970 interventional studies registered on or after October 1, 2007. Searched for studies with nephrology-specific terms in AACT(2010).Conditions, OR AACT(2010).Keywords, OR AACT(2010).MeSH_Trees (where MeSH_Type='condition). Investigators then reviewed the resulting list of studies and identified the final cohort of 1054 nephrology trials reported in the manuscript."
        },
      ]
    end

    def self.attachments
      []
    end

    def self.populate
      #ProjTagPulmonary::AnalyzedStudy.populate
    end

  end
end
