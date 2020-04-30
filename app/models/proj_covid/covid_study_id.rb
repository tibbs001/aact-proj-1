module ProjCovid
  class CovidStudyId < ActiveRecord::Base
    self.table_name = 'proj_covid.covid_study_ids'

    def self.populate
      self.destroy_all
      # Retrieve the current list of COVID-related NCT-IDs from ct.gov RSS feed
      file_name = "public/covid_study_ids.csv"
      curl_cmd = "curl 'https://clinicaltrials.gov/ct2/results/rss.xml?rcv_d=&lup_d=&sel_rss=mod14&cond=COVID-19&count=99999' | grep 'link' | cut -c 49-59 > #{file_name}"
      system(curl_cmd)
      conn = ActiveRecord::Base.connection.raw_connection
      conn.exec("COPY proj_covid.covid_study_ids (nct_id) FROM STDIN")
      data = File.open(file_name)
      data::gets
      data.each { |line|
        conn.put_copy_data(line + ",,")
      }
      conn.put_copy_end
    end

  end
end
