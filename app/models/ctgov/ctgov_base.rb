module Ctgov
  class CtgovBase < ActiveRecord::Base
    establish_connection(ENV["AACT_PUBLIC_DATABASE_URL"])
    self.abstract_class = true
  end
end
