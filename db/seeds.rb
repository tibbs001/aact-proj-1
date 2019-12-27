# This defines all commands to populate the AACT Projects system
# Projects are stored in their own database schema.  The process drops & recreates these project schemas
# then runs the project migration file to create project-related table(s) in the project's schema

Util::Updater.run

