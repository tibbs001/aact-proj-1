module ProjTagNephrology
  class TaggedTerm < ActiveRecord::Base
    self.table_name = 'proj_tag_nephrology.tagged_terms'

    def self.populate
      file_name = ProjTagNephrology::ProjectInfo.datasets.select{|ds| ds[:table_name] == 'tagged_terms'}.first[:file_name]
      self.populate_from_file(file_name)
    end

    def self.populate_from_file(file_name)
      connection.execute("TRUNCATE TABLE #{table_name};")
      data = Roo::Spreadsheet.open(file_name).sheet("Analysis Data")
      header = data.first.compact.map(&:downcase)

      (2..data.last_row).each  {|i|
        row = Hash[[header, data.row(i)].transpose]
        create(:tag => 'nephrology', :term => row['term'].downcase.strip, :term_type=> row['type'].downcase.strip).save!  if !row['term'].blank?
      }
    end

  end
end
