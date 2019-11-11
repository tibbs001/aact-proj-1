# README

AACT Data Sharing - We are sharing the data from projects that have used AACT as a data source.


* Ruby version: 2.4.5

* System dependencies:  AACT public database at aact-db.ctti-clinicaltrials.org:5432

* Configuration

* Each data share project has a directory under app/models & the project_info.rb file defines all properties for the project

* Database creation:  A database schema is created for each data share project.

* Database initialization:  It does not drop or create the database.  It only drops/creates project-related schemas.

* Deployment instructions

** bundle exec rake db:drop
** bundle exec rake db:create
** bundle exec rake db:migrate
** bundle exec rake db:seed

