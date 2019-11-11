require 'roo'
module ProjResultsReporting
  class ProjectInfo < ProjectInfoTemplate

    def self.meta_info
      #  Required:  name, schema_name & migration_file_name
      { name:                'Compliance with Results Reporting at ClinicalTrials.gov',
        schema_name:         'proj_results_reporting',
        migration_file_name:  Rails.root.join('db','migrate','20180918000122_create_proj_results_reporting_tables.rb').to_s,
        investigators:       'Monique L. Anderson, M.D., Karen Chiswell, Ph.D., Eric D. Peterson, M.D., M.P.H., Asba Tasneem, Ph.D., James Topping, M.S., and Robert M. Califf, M.D.',
        organizations:       'Duke Clinical Research Institute',
        contact_info:        'Monique Anderson. Duke University, Dept of Medicine, Box 3099, Durham C 27710 monique.starks@duke.edu',
        contact_url:         'https://scholars.duke.edu/person/moniqueanderson.starks',
        data_available:      true,
        aact_version:        'September 27, 2013',
        start_date:          Date.strptime('27/09/2013', '%d/%m/%Y'),
        year:                2015,
        url:                 'https://www.nejm.org/doi/full/10.1056/NEJMsa1409364',
        email:               'monique.starks@duke.edu',
        brief_summary:       'Analysis of the levels & patterns of compliance with FDAAA reporting regulations for trials conducted between 2008 & 2013 (considering only those trials that are highly likely to be applicable to FDAAA provisions).',
        description:         'From published Abstract: From all the trials at ClinicalTrials.gov, we identified 13,327 HLACTs that were terminated or completed from January 1, 2008, through August 31, 2012. Of these trials, 77.4% were classified as drug trials. A total of 36.9% of the trials were phase 2 studies, and 23.4% were phase 3 studies; 65.6% were funded by industry. Only 13.4% of trials reported summary results within 12 months after trial completion, whereas 38.3% reported results at any time up to September 27, 2013. Timely reporting was independently associated with factors such as FDA oversight, a later trial phase, and industry funding. A sample review suggested that 45% of industry-funded trials were not required to report results, as compared with 6% of trials funded by the National Institutes of Health (NIH) and 9% of trials that were funded by other government or academic institutions.',
        study_selection_criteria: "From published Abstract: Using an algorithm based on input from the National Library of Medicine, we identified trials that were likely to be subject to FDAAA provisions (highly likely applicable clinical trials, or HLACTs) from 2008 through 2013. We determined the proportion of HLACTs that reported results within the 12-month interval mandated by the FDAAA or at any time during the 5-year study period. We used regression models to examine characteristics associated with reporting at 12 months and throughout the 5-year study period.",
      }
    end

    def self.publications
      [
        {
          journal_name:     'The New England Journal of Medicine',
          publication_date: Date.strptime('12/03/2015', '%d/%m/%Y'),
          pub_type:         'AcademicArticle',
          pmid:             '25760355',
          pmcid:            'PMC4508873',
          doi:              '10.1056/NEJMsa1409364',
          title:            'Compliance with Results Reporting at ClinicalTrials.gov',
          url:              'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4508873/',
          citation:         'Anderson ML, Chiswell K, Peterson ED, Tasneem A, Topping J, Califf RM. Compliance with results reporting at ClinicalTrials. gov. New England Journal of Medicine. 2015 Mar 12;372(11):1031-9.'
        }
      ]
    end

    def self.attachments
      [
        {
          description: 'Data Definitions',
          file_name:   "#{Rails.public_path}/attachments/proj_results_reporting_data_defs.xlsx",
          file_type: 'application/vnd.openxmlformats-officedocument.spreads'
        },
      ]
    end

    def self.datasets
      [
        {
          dataset_type: 'study list',
          schema_name:  'proj_results_reporting',
          table_name:   'analyzed_studies',
          name:         'Analyzed Studies',
          file_name:    "#{Rails.public_path}/attachments/proj_results_reporting_studies.xlsx",
          file_type:    'application/vnd.openxmlformats-officedocument.spreads',
          description:  "",
          source:       "Trials selected from AACT by applying algorithm to identify trials highly likely to be 'Applicable Clinical Trials' (see table S1 in supplemental material to manuscript)."
        }
      ]
    end

    def self.populate
      ProjResultsReporting::AnalyzedStudy.populate
    end

  end
end
