module ProjTagStudyCharacteristics
  class CardiovascularStudy < ActiveRecord::Base
    self.table_name = 'proj_tag_study_characteristics.cardiovascular_studies'

    def self.populate
      file_name = ProjTagStudyCharacteristics::ProjectInfo.datasets.select{|ds| ds[:name] == 'Analyzed Studies'}.first[:file_name]
      self.populate_from_file(file_name)
    end

    def self.populate_from_file(file_name)
      connection.execute("TRUNCATE TABLE #{table_name};")
      data = Roo::Spreadsheet.open(file_name).sheet("Cardiovascular")
      header = data.first.compact.map(&:downcase)
      (2..data.last_row).each  {|i|
        row = Hash[[header, data.row(i)].transpose]
        if !row['nct_id'].blank?
          create(
            :nct_id                   => row['nct_id'].try(:strip),
            :brief_title              => row['brief_title'].try(:strip),
            :lead_sponsor             => row['lead_sponsor'].try(:strip),
          ).save!
        end
      }
    end

  end
end
