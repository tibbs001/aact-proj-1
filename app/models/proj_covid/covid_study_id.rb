module ProjCovid
  class CovidStudyId < ActiveRecord::Base
    self.table_name = 'proj_covid.covid_study_ids'

    def self.populate
      self.destroy_all
      Util::RssReader.new.get_covid_nct_ids.each {|nct_id| create({:nct_id => nct_id}) }
      puts "=========="
      puts "Number of COVID studies:  #{self.count}"
      puts "=========="
    end

  end
end
