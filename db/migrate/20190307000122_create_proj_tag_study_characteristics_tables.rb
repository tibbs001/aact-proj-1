class CreateProjTagStudyCharacteristicsTables < ActiveRecord::Migration[5.2]

  def up

    execute "CREATE SCHEMA proj_tag_study_characteristics;"
    execute "GRANT USAGE ON SCHEMA proj_tag_study_characteristics to read_only;"
    execute "GRANT SELECT ON ALL TABLES IN SCHEMA proj_tag_study_characteristics TO read_only;"

    create_table "proj_tag_study_characteristics.tagged_terms" do |t|
      t.string  'tag'
      t.string  'term'
      t.string  'term_type'
    end

    create_table "proj_tag_study_characteristics.cardiovascular_studies" do |t|
      t.string  'nct_id'
      t.string  :brief_title
      t.string  :lead_sponsor
    end

    create_table "proj_tag_study_characteristics.oncology_studies" do |t|
      t.string  'nct_id'
      t.string  :brief_title
      t.string  :lead_sponsor
    end

    create_table "proj_tag_study_characteristics.mental_health_studies" do |t|
      t.string  'nct_id'
      t.string  :brief_title
      t.string  :lead_sponsor
    end

  end

  def down
    execute "DROP SCHEMA proj_tag_study_characteristics CASCADE;"
  end

end
