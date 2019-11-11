module ProjTagPvd
  class ProjectInfo < ProjectInfoTemplate

    def self.meta_info
      { name:                 'Clinical trials in peripheral vascular disease: pipeline and trial designs: an evaluation of the ClinicalTrials.gov database',
        schema_name:          'proj_tag_pvd',
        brief_summary:        "",
        investigators:        'Subherwal S, Patel MR, Chiswell K, Tidemann-Miller BA, Jones WS, Conte MS, White CJ, Bhatt DL, Laird JR, Hiatt WR, Tasneem A.',
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
        journal_name:     'Circulation',
        publication_date: Date.strptime('05/01/2014', '%d/%m/%Y'),
        pub_type:         'AcademicArticle',
        title:            'Clinical trials in peripheral vascular disease: pipeline and trial designs: an evaluation of the ClinicalTrials.gov database.',
        url:              'https://www.ncbi.nlm.nih.gov/pubmed/25239436',
        pmid:             '25239436',
        pmcid:            'PMC4362518',
        doi:              '10.1161/CIRCULATIONAHA.114.011021',
        citation:         'Subherwal S, Patel MR, Chiswell K, Tidemann-Miller BA, Jones WS, Conte MS, White CJ, Bhatt DL, Laird JR, Hiatt WR, Tasneem A. Clinical trials in peripheral vascular disease: pipeline and trial designs: an evaluation of the ClinicalTrials.gov database. Circulation. 2014 Sep 19:CIRCULATIONAHA-114.'
      }]
    end

    def self.datasets
      [
        {
          dataset_type: 'terms',
          schema_name:  'proj_tag_pvd',
          table_name:   'tagged_terms',
          name:         'Peripheral Vascular Disease Terms (MeSH & Free Text)',
          file_name:    "#{Rails.public_path}/attachments/proj_tag_pvd_terms.xlsx",
          file_type:    'application/vnd.openxmlformats-officedocument.spreads',
          description:  'xxxxx unique MeSH condition terms & xxx unique free text condition terms tagged for peripheral vascular disease',
          source:       'The MeSH terms are from the 2010 MeSH thesaurus, terms in branches C, E, F, G. The free text terms are those  that occurred in AACT(2010).Conditions field with frequency >=5 among interventional studies registered on or after Oct 1, 2007, and that did not exist in MeSH thesaurus.'
        },
        {
          dataset_type: 'study list',
          schema_name:  'proj_tag_pvd',
          table_name:   'analyzed_studies',
          name:         'Analyzed Studies',
          file_name:    "#{Rails.public_path}/attachments/proj_tag_pvd_studies.xlsx",
          file_type:    'application/vnd.openxmlformats-officedocument.spreads',
          source:       "From AACT(2010), subset on 40,970 interventional studies registered on or after October 1, 2007. Searched for studies with peripheral vascular disease-specific terms in AACT(2010).Conditions, OR AACT(2010).Keywords, OR AACT(2010).MeSH_Trees (where MeSH_Type='condition). Investigators then reviewed the resulting list of studies and identified the final cohort of xxxxx peripheral vascular disease trials reported in the manuscript."
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
