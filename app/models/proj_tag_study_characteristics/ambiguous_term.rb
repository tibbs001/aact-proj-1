module ProjTagStudyCharacteristics
  class AmbiguousTerm < ActiveRecord::Base

    self.table_name = 'proj_tag_study_characteristics.tagged_terms'

    def self.populate
      connection.execute("DELETE FROM #{table_name} WHERE term_type='ambiguous';")
      data = self.get_from_spreadsheet
      header = data.first.compact.map(&:downcase)

      (2..data.last_row).each  {|i|
        row = Hash[[header, data.row(i)].transpose]
        term=row['term'].downcase.strip
        if !row['term'].blank? and !row['tag'].blank?
          create(:tag => row['tag'].downcase.strip, :term => term, :term_type=> 'ambiguous').save!
        end
      }
    end

    def self.get_from_spreadsheet
      file_name = ProjTagStudyCharacteristics::ProjectInfo.datasets.select{|ds| ds[:dataset_type] == 'terms'}.first[:file_name]
      Roo::Spreadsheet.open(file_name).sheet('Ambiguous Terms')
    end

    def self.terms_for(specialty)
      data = self.get_from_spreadsheet
      header = data.first.compact.map(&:downcase)
      terms = []

      (2..data.last_row).each  {|i|
        row = Hash[[header, data.row(i)].transpose]
        tag=row['tag'].downcase.strip
        term=row['term'].downcase.strip
        terms << term if tag == specialty and !term.blank? and !tag.blank?
      }
      return terms
    end

  end
end
