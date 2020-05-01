namespace :populate do
  task covid_studies: [:environment] do
    ProjCovid::CovidStudyId.populate
  end
end
