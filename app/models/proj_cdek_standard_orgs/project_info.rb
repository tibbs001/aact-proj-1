module ProjCdekStandardOrgs
  class ProjectInfo < ProjectInfoTemplate

    def self.meta_info
    {
     name:           'CDEK’s Standard Organization Names',
     schema_name:    'proj_cdek_standard_orgs',
     migration_file_name:  Rails.root.join('db','migrate','20181108000122_create_proj_cdek_standard_orgs_tables.rb').to_s,
     brief_summary: "The CDEK project at Washington University has curated organization data to begin standardizing this terminology. Because an organization may be identified several different ways in ClinicalTrials.gov, it's often difficult to accurately identify all studies associated with an organization. Washington University has creating a queryable 'organization index' that provides a way for AACT users to more easily identify all studies associated with an organization.",
    investigators:  'Rebekah Griesenauer, PhD, Postdoctoral Scholar; Michael S Kinch, PhD, Associate Vice Chancellor',
     organizations:  'Washington University - St. Louis. Center for Research Innovation and Biotechnology',
     contact_info:   'CDEK was developed and is maintained by the Center for Research Innovation in Biotechnology (CRIB) at Washington University in St. Louis. CRIB studies the blend of science, business, and regulation of biotechnology, medical devices, and healthcare IT to ensure continued improvements in the delivery of medical innovations and public health. CRIB is actively pursuing collaborations to study the data within CDEK. Errors and suggestions for improvement can be submitted at http://cdek.wustl.edu/about/. Or contact us via e-mail at cdek at wustl dot edu.',
     contact_url:    'http://cdek.wustl.edu/about/',
     data_available: true,
     start_date:     Date.strptime('27/09/2016', '%d/%m/%Y'),
     year:           2018,
     description:  "Clinical Drug Experience Knowledgebase (CDEK) is a database and web-platform to enable researchers and analysts to study all active pharmaceutical ingredients with evidence of clinical experience in humans. CDEK contains over 20,000 active pharmaceutical ingredients with surrounding annotated metadata (i.e. sponsoring organizations, indications, clinical trial data, chemical structure, etc). The Washington University team curated CDEK in part by disambiguating intervention and organization names from ClinicalTrials.gov (through AACT). This information was cross-referenced against entries in prominent international drug databases (e.g. PubChem, ChEMBL, DrugBank). The prototype web-application is designed to allow researchers of all backgrounds to access and query the data. It can be found at cdek.wustl.edu.

Organizations are often identified by a variety of names in ClinicalTrials.gov, making it difficult to correctly identify all studies associated with an organization. For example, ‘Washington University-St. Louis' and ‘Washington University School of Medicine' are both considered “Washington University in St. Louis”. In fact, Washington University in St. Louis and its schools/institutes, are represented 63 different ways in ClinicalTrials.gov.

The CDEK curation process currently focuses on organizations/affiliations identified as the sponsor, overall official or responsible parties for drug intervention trials in ClinicalTrials.gov as of September, 2017. (Organizations in the 'facilities' table were not included.) Each organization name was assigned a standardized 'preferred' (or parent) name, effectively creating an index of names that map the variety of names to a common name, making it easier to group studies by organization.

The organization information curated for the CDEK project is now available in AACT.",
     }
    end

    def self.publications
      [{
        journal_name:     'BioRxiv  The Preprint Server for Biology',
        publication_date: Date.strptime('11/19/2018', '%m/%d/%Y'),
        pub_type:         'AcademicArticle',
        title:            'CDEK: Clinical Drug Experience Knowledgebase',
        url:              'http://dx.doi.org/10.1101/474189',
        doi:              '10.1101/474189',
        citation:         'Griesenauer R, Schillebeeck C, Kinch MS. CDEK: Clinical Drug Experience Knowledgebase. bioRxiv  The Preprint Server for Biology. 2018 November 19'
      }]
    end

    def self.attachments
      [
        {
          description: 'Data Definitions',
          file_name:   "#{Rails.public_path}/attachments/proj_cdek_standard_orgs_data_defs.xlsx",
          file_type: 'application/vnd.openxmlformats-officedocument.spreads'
        },
      ]
    end

    def self.datasets
      [
        {
          dataset_type: 'terms',
          schema_name:  'proj_cdek_standard_orgs',
          table_name:   'cdek_organizations',
          name:         'CDEK Standardized Organization Names',
          file_name:    "#{Rails.public_path}/attachments/proj_cdek_standard_orgs_organizations.xlsx",
          file_type:    'application/vnd.openxmlformats-officedocument.spreads'
        },
        {
          dataset_type: 'links',
          schema_name:  'proj_cdek_standard_orgs',
          table_name:   'cdek_synonyms',
          name:         'CDEK Organization Synonyms',
          file_name:    "#{Rails.public_path}/attachments/proj_cdek_standard_orgs_synonyms.xlsx",
          file_type:    'application/vnd.openxmlformats-officedocument.spreads'
        },
      ]
    end

    def self.populate
      ProjCdekStandardOrgs::CdekOrganization.populate
      ProjCdekStandardOrgs::CdekSynonym.populate
    end

  end
end

