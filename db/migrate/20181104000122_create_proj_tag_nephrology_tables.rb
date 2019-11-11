class CreateProjTagNephrologyTables < ActiveRecord::Migration[5.2]

  def up

    execute "CREATE SCHEMA proj_tag_nephrology;"
    execute "GRANT USAGE ON SCHEMA proj_tag_nephrology to read_only;"
    execute "GRANT SELECT ON ALL TABLES IN SCHEMA proj_tag_nephrology TO read_only;"
    create_table "proj_tag_nephrology.tagged_terms" do |t|
      t.string  'tag'
      t.string  'term'
      t.string  'term_type'
    end

    create_table "proj_tag_nephrology.analyzed_studies" do |t|
      t.string  'nct_id'
      t.string  'brief_title'
      t.string  'lead_sponsor'
    end

    #  Views that join across schemas can cause problem for pg_restore. It can get hung up on
    #  dependencies when it's trying to drop/refresh one schema that joins to another
    #  through a view. To get around this problem, we use functions that create the views.
    #  When Core AACT restores the Public Database by dumping/restoring the staging database,
    #  it drops all views before hand. When it's done restoring, it runs a function to recreate
    #  the view.
    #execute <<-SQL
    #    CREATE OR REPLACE FUNCTION proj_tag_nephrology.create_views() RETURNS void AS
    #    $BODY$
    #    BEGIN
    #      EXECUTE 'CREATE OR REPLACE VIEW proj_tag_nephrology.tagged_studies AS ' ||
    #        ' select distinct s.nct_id, s.start_date, s.start_date_type, s.primary_completion_date, s.primary_completion_date_type, ' ||
    #        '   s.acronym, s.brief_title, s.official_title, s.overall_status, s.phase, ' ||
    #        '   s.source, s.number_of_arms, s.enrollment, ' ||
    #        '   regexp_replace(s.baseline_population, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as baseline_population,  ' ||
    #        '   regexp_replace(s.why_stopped, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as why_stopped,  ' ||
    #        '   regexp_replace(s.limitations_and_caveats, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as limitations_and_caveats,  ' ||
    #        '   cv.number_of_facilities, cv.actual_duration, ' ||
    #        '   cv.were_results_reported, cv.has_us_facility, cv.has_single_facility, ' ||
    #        '   cv.months_to_report_results , cv.minimum_age_num, cv.minimum_age_unit, ' ||
    #        '   cv.maximum_age_num, cv.maximum_age_unit, ' ||
    #        '   d.allocation, d.intervention_model, d.primary_purpose, d.time_perspective, d.masking  ' ||
    #        '   from ctgov.studies s, ctgov.calculated_values cv, ctgov.designs d ' ||
    #        '   where s.nct_id = cv.nct_id ' ||
    #        '     and s.nct_id = d.nct_id  ' ||
    #        '     and s.nct_id in (        ' ||
    #          ' select distinct s.nct_id   ' ||
    #           ' from ctgov.studies s, ctgov.browse_conditions bc ' ||
    #           ' where s.study_type=''Interventional''  ' ||
    #             ' and s.study_first_posted_date >= ''2007-10-01'' ' ||
    #             ' and s.nct_id = bc.nct_id ' ||
    #             ' and bc.downcase_mesh_term IN (select term from proj_tag_nephrology.tagged_terms) '
    #          ' union ' ||
    #          '   select distinct s.nct_id ' ||
    #          '   from ctgov.studies s, ctgov.keywords k ' ||
    #          '   where s.study_type=''Interventional'' ' ||
    #          '   and s.study_first_posted_date >= ''2007-10-01'' ' ||
    #          '   and s.nct_id = k.nct_id ' ||
    #          '  and k.downcase_name IN (select term from proj_tag_nephrology.tagged_terms)  ' ||
    #          ' union  ' ||
    #          '   select distinct s.nct_id  ' ||
    #          '   from studies s, conditions c  ' ||
    #          '   where s.study_type=''Interventional''  ' ||
    #          '   and s.study_first_posted_date >= ''2007-10-01''  ' ||
    #          '   and s.nct_id = c.nct_id  ' ||
    #          '   and c.downcase_name IN (select term from proj_tag_nephrology.tagged_terms)  ' ||
    #          '   ) ';
#
##          RETURN;
#        END;
#        $BODY$ LANGUAGE plpgsql STRICT;
#     SQL

  end

  def down
    execute "DROP SCHEMA proj_tag_nephrology CASCADE;"
  end

end
