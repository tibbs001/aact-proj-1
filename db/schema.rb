# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_24_000122) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analyzed_studies", force: :cascade do |t|
    t.string "nct_id"
    t.string "url"
    t.string "brief_title"
    t.string "start_month"
    t.integer "start_year"
    t.string "overall_status"
    t.string "p_completion_month"
    t.integer "p_completion_year"
    t.string "completion_month"
    t.integer "completion_year"
    t.string "verification_month"
    t.integer "verification_year"
    t.integer "p_comp_mn"
    t.integer "p_comp_yr"
    t.integer "received_year"
    t.integer "mntopcom"
    t.integer "enrollment"
    t.integer "number_of_arms"
    t.string "allocation"
    t.string "masking"
    t.string "phase"
    t.string "primary_purpose"
    t.string "sponsor_name"
    t.string "agency_class"
    t.string "collaborator_names"
    t.string "funding"
    t.string "responsible_party_type"
    t.string "responsible_party_organization"
    t.string "us_coderc"
    t.string "oversight"
    t.string "behavioral"
    t.string "biological"
    t.string "device"
    t.string "dietsup"
    t.string "drug"
    t.string "genetic"
    t.string "procedure"
    t.string "radiation"
    t.string "otherint"
    t.string "intervg1"
    t.string "results"
    t.string "resultsreceived_month"
    t.string "resultsreceived_year"
    t.date "firstreceived_results_dt"
    t.integer "t2result"
    t.integer "t2result_imp"
    t.integer "t2resmod"
    t.string "results12"
    t.string "delayed"
    t.date "dr_received_dt"
    t.boolean "mn2delay"
    t.boolean "delayed12"
  end

  create_table "analyzed_studies", force: :cascade do |t|
    t.string "nct_id"
    t.string "url"
    t.string "brief_title"
    t.string "start_month"
    t.integer "start_year"
    t.string "overall_status"
    t.string "p_completion_month"
    t.integer "p_completion_year"
    t.string "completion_month"
    t.integer "completion_year"
    t.string "verification_month"
    t.integer "verification_year"
    t.integer "p_comp_mn"
    t.integer "p_comp_yr"
    t.integer "received_year"
    t.integer "mntopcom"
    t.integer "enrollment"
    t.integer "number_of_arms"
    t.string "allocation"
    t.string "masking"
    t.string "phase"
    t.string "primary_purpose"
    t.string "sponsor_name"
    t.string "agency_class"
    t.string "collaborator_names"
    t.string "funding"
    t.string "responsible_party_type"
    t.string "responsible_party_organization"
    t.string "us_coderc"
    t.string "oversight"
    t.string "behavioral"
    t.string "biological"
    t.string "device"
    t.string "dietsup"
    t.string "drug"
    t.string "genetic"
    t.string "procedure"
    t.string "radiation"
    t.string "otherint"
    t.string "intervg1"
    t.string "results"
    t.string "resultsreceived_month"
    t.string "resultsreceived_year"
    t.date "firstreceived_results_dt"
    t.integer "t2result"
    t.integer "t2result_imp"
    t.integer "t2resmod"
    t.string "results12"
    t.string "delayed"
    t.date "dr_received_dt"
    t.boolean "mn2delay"
    t.boolean "delayed12"
  end

  create_table "cardiovascular_studies", force: :cascade do |t|
    t.string "nct_id"
    t.string "brief_title"
    t.string "lead_sponsor"
  end

  create_table "cdek_organizations", force: :cascade do |t|
    t.string "name"
    t.string "downcase_name"
  end

  create_table "cdek_synonyms", force: :cascade do |t|
    t.string "name"
    t.string "preferred_name"
    t.string "downcase_name"
    t.string "downcase_preferred_name"
  end

  create_table "covid_study_ids", force: :cascade do |t|
    t.string "nct_id"
  end

  create_table "mental_health_studies", force: :cascade do |t|
    t.string "nct_id"
    t.string "brief_title"
    t.string "lead_sponsor"
  end

  create_table "oncology_studies", force: :cascade do |t|
    t.string "nct_id"
    t.string "brief_title"
    t.string "lead_sponsor"
  end

  create_table "tagged_terms", force: :cascade do |t|
    t.string "tag"
    t.string "term"
    t.string "term_type"
  end

  create_table "tagged_terms", force: :cascade do |t|
    t.string "tag"
    t.string "term"
    t.string "term_type"
  end

  create_table "y2010_mesh_terms", force: :cascade do |t|
    t.string "qualifier"
    t.string "tree_number"
    t.string "description"
    t.string "mesh_term"
    t.string "downcase_mesh_term"
    t.index ["description"], name: "index_mesh_archive.y2010_mesh_terms_on_description"
    t.index ["downcase_mesh_term"], name: "index_mesh_archive.y2010_mesh_terms_on_downcase_mesh_term"
    t.index ["mesh_term"], name: "index_mesh_archive.y2010_mesh_terms_on_mesh_term"
    t.index ["qualifier"], name: "index_mesh_archive.y2010_mesh_terms_on_qualifier"
  end

  create_table "y2016_mesh_headings", force: :cascade do |t|
    t.string "qualifier"
    t.string "heading"
    t.string "subcategory"
    t.index ["qualifier"], name: "index_mesh_archive.y2016_mesh_headings_on_qualifier"
  end

  create_table "y2016_mesh_terms", force: :cascade do |t|
    t.string "qualifier"
    t.string "tree_number"
    t.string "description"
    t.string "mesh_term"
    t.string "downcase_mesh_term"
    t.index ["description"], name: "index_mesh_archive.y2016_mesh_terms_on_description"
    t.index ["downcase_mesh_term"], name: "index_mesh_archive.y2016_mesh_terms_on_downcase_mesh_term"
    t.index ["mesh_term"], name: "index_mesh_archive.y2016_mesh_terms_on_mesh_term"
    t.index ["qualifier"], name: "index_mesh_archive.y2016_mesh_terms_on_qualifier"
  end

  create_table "y2018_mesh_terms", force: :cascade do |t|
    t.string "qualifier"
    t.string "tree_number"
    t.string "description"
    t.string "mesh_term"
    t.string "downcase_mesh_term"
    t.index ["description"], name: "index_mesh_archive.y2018_mesh_terms_on_description"
    t.index ["downcase_mesh_term"], name: "index_mesh_archive.y2018_mesh_terms_on_downcase_mesh_term"
    t.index ["mesh_term"], name: "index_mesh_archive.y2018_mesh_terms_on_mesh_term"
    t.index ["qualifier"], name: "index_mesh_archive.y2018_mesh_terms_on_qualifier"
  end

end
