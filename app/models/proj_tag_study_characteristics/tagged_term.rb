module ProjTagStudyCharacteristics
  class TaggedTerm < ActiveRecord::Base
    self.table_name = 'proj_tag_study_characteristics.tagged_terms'

    def self.populate
      file_name = ProjTagStudyCharacteristics::ProjectInfo.datasets.select{|ds| ds[:dataset_type] == 'terms'}.first[:file_name]
      connection.execute("TRUNCATE TABLE #{table_name};")
      ['Mental Health','Oncology','Cardiovascular'].each { |specialty|
        self.populate_from_file(file_name, specialty)
      }
    end

    def self.populate_from_file(file_name, specialty)
      data = Roo::Spreadsheet.open(file_name).sheet(specialty)
      header = data.first.compact.map(&:downcase)
      ambiguous_terms = ProjTagStudyCharacteristics::AmbiguousTerm.terms_for(specialty.downcase)

      (2..data.last_row).each  {|i|
        row = Hash[[header, data.row(i)].transpose]
        term=row['term'].downcase.strip
        if !row['term'].blank? and !ambiguous_terms.include?(term)
          create(:tag => specialty.downcase.strip, :term => term, :term_type=> row['type'].downcase.strip).save!
        end
      }
    end

  end
end
