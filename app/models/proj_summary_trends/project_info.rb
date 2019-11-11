module ProjSummaryTrends
  class ProjectInfo < ProjectInfoTemplate

    def self.meta_info
      #  Required:  name & schema_name
      #  If migration_file_name defined, add code that will populate it to the method below: populate
      { name:                'Summaries and Trends of Interventional Trials in ClinicalTrials.gov 2008-2017',
        schema_name:         'proj_summary_trends',
        investigators:       'Karen Chiswell',
        organizations:       'Duke Clinical Research Institute',
        data_available:      false,
        start_date:          Date.strptime('27/09/2017', '%d/%m/%Y'),
        year:                2017,
        email:               'karen.chiswell@duke.edu',
        brief_summary:       'Examination & visualizations of the characteristics of trials conducted between 2008 & 2017 and how they have changed over time.',
        description:         "We were interested in examining how the characteristics of trials registered at ClinicalTrials.gov have changed over time.",
        study_selection_criteria: "We accessed the AACT database using SAS(R) v 9.4. Our analysis was restricted to interventional studies registered between 2008-2017. We classified trials according to Funding source (Industry/NIH/Other, derived from sponsor and collaborator fields), Phase, Intervention Type, Site Location (U.S. sites compared to sites in the rest of the world), and appointment of a Data Monitoring Committee. We also examined patterns in months from study start to completion, and in months from study completion to reporting of results at ClinicalTrials.gov in selected subgroups of studies. In this version we examined completeness of a few of the new data elements (e.g., about inclusion of a US FDA regulated drug product). An example graph is displayed in the image file displayed above. The attached Excel file displays additional graphs. To create the Excel file we generated summary numbers from SAS, output them, and created the graphs in Excel. Graphs were also generated directly using SAS procedures and output to a PDF file (see code and output shared via GitHub)."
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
          description: "Spreadsheet containing details of data trends in ClinicalTrials.gov",
          file_name: "#{Rails.public_path}/attachments/proj_summary_trends.xlsx",
          file_type: 'application/vnd.openxmlformats-officedocument.spreads'
        },
        {
          description: "Sample illustration of data trends in ClinicalTrials.gov",
          file_name: "#{Rails.public_path}/attachments/proj_summary_trends.png",
          file_type: 'image'
        },
      ]
    end

    def self.populate
    end

  end
end
