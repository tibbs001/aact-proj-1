require 'rss'
require 'uri'

module Util
  class RssReader
    BASE_URL = 'https://clinicaltrials.gov'
    PAGE_SIZE = 1000
    #https://clinicaltrials.gov/ct2/results/rss.xml?lup_d=4&count=10000

    attr_reader :changed_url, :added_url

    def initialize
      @covid_url = "#{BASE_URL}/ct2/results/rss.xml?sel_rss=mod&cond=COVID-19&count=#{PAGE_SIZE}"
    end

    def get_covid_nct_ids
      list = []
      start = 0
      loop do
        result = get_covid_nct_ids_batch(start)
        list += result
        start += PAGE_SIZE
        break if result.length == 0
      end
      list
    end

    def get_covid_nct_ids_batch(start)
      tries ||= 5
      begin
        feed = RSS::Parser.parse("#{@covid_url}&start=#{start}", false)
        feed.items.map(&:guid).map(&:content)
      rescue  Exception => e
        if (tries -=1) > 0
          puts "Failed: #{@covid_url}.  trying again..."
          puts "Error: #{e}"
          retry
        else #give up & return empty array
          []
        end
      end
    end

  end
end