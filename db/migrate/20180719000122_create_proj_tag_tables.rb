class CreateProjTagTables < ActiveRecord::Migration[5.2]

  def up

    execute "CREATE SCHEMA proj_tag;"
    execute "GRANT USAGE ON SCHEMA proj_tag to read_only;"
    execute "GRANT SELECT ON ALL TABLES IN SCHEMA proj_tag TO read_only;"
    create_table "proj_tag.tagged_terms" do |t|
      t.integer 'project_id'
      t.string  'identifier'
      t.string  'tag'
      t.string  'term'
      t.string  'year'
      t.string  'term_type'
    end

    #  Views that join across schemas can cause problem for pg_restore. It can get hung up on
    #  dependencies when it's trying to drop/refresh one schema that joins to another
    #  through a view. To get around this problem, we use functions that create the views.
    #  When Core AACT restores the Public Database by dumping/restoring the staging database,
    #  it drops all views before hand. When it's done restoring, it runs a function to recreate
    #  the view.
    #
    #  The views created below show:
    #    Interventional trials posted since 10/1/2007 (because prior to that, some data elements (such as studies.has_dmc & studies.number_of_arms
    #    were not being reported in ct.gov
    #    Join by term to browse_conditions, browse_interventions & keywords.

    execute <<-SQL
        CREATE OR REPLACE FUNCTION proj_tag.create_views() RETURNS void AS
        $BODY$
        BEGIN
          EXECUTE 'CREATE OR REPLACE VIEW proj_tag.current_nephrology_studies AS ' ||
            ' select distinct s.nct_id, s.start_date, s.start_date_type, s.primary_completion_date, s.primary_completion_date_type, ' ||
            '   s.acronym, s.brief_title, s.official_title, s.overall_status, s.phase, ' ||
            '   s.source, s.number_of_arms, s.enrollment, ' ||
            '   regexp_replace(s.baseline_population, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as baseline_population,  ' ||
            '   regexp_replace(s.why_stopped, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as why_stopped,  ' ||
            '   regexp_replace(s.limitations_and_caveats, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as limitations_and_caveats,  ' ||
            '   cv.number_of_facilities, cv.actual_duration, ' ||
            '   cv.were_results_reported, cv.has_us_facility, cv.has_single_facility, ' ||
            '   cv.months_to_report_results , cv.minimum_age_num, cv.minimum_age_unit, ' ||
            '   cv.maximum_age_num, cv.maximum_age_unit, ' ||
            '   d.allocation, d.intervention_model, d.primary_purpose, d.time_perspective, d.masking  ' ||
            '   from ctgov.studies s, ctgov.calculated_values cv, ctgov.designs d ' ||
            '   where s.nct_id = cv.nct_id ' ||
            '     and s.nct_id = d.nct_id  ' ||
            '     and s.nct_id in (        ' ||
              ' select distinct s.nct_id   ' ||
               ' from ctgov.studies s, ctgov.browse_conditions bc ' ||
               ' where s.study_type=''Interventional''  ' ||
                 ' and s.study_first_posted_date >= ''2007-10-01'' ' ||
                 ' and s.nct_id = bc.nct_id ' ||
                 ' and bc.downcase_mesh_term IN (select term from proj_tag_nephrology.tagged_terms) '
              ' union ' ||
              '   select distinct s.nct_id ' ||
              '   from ctgov.studies s, ctgov.keywords k ' ||
              '   where s.study_type=''Interventional'' ' ||
              '   and s.study_first_posted_date >= ''2007-10-01'' ' ||
              '   and s.nct_id = k.nct_id ' ||
              '  and k.downcase_name IN (select term from proj_tag_nephrology.tagged_terms)  ' ||
              ' union  ' ||
              '   select distinct s.nct_id  ' ||
              '   from ctgov.studies s, ctgov.conditions c  ' ||
              '   where s.study_type=''Interventional''  ' ||
              '   and s.study_first_posted_date >= ''2007-10-01''  ' ||
              '   and s.nct_id = c.nct_id  ' ||
              '   and c.downcase_name IN (select term from proj_tag_nephrology.tagged_terms)  ' ||
              '   ) ';

         EXECUTE 'CREATE OR REPLACE VIEW proj_tag.current_mental_health_studies AS ' ||
            ' select distinct s.nct_id, s.start_date, s.start_date_type, s.primary_completion_date, s.primary_completion_date_type, ' ||
            '   s.acronym, s.brief_title, s.official_title, s.overall_status, s.phase, ' ||
            '   s.source, s.number_of_arms, s.enrollment, ' ||
            '   regexp_replace(s.baseline_population, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as baseline_population,  ' ||
            '   regexp_replace(s.why_stopped, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as why_stopped,  ' ||
            '   regexp_replace(s.limitations_and_caveats, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as limitations_and_caveats,  ' ||
            '   cv.number_of_facilities, cv.actual_duration, ' ||
            '   cv.were_results_reported, cv.has_us_facility, cv.has_single_facility, ' ||
            '   cv.months_to_report_results , cv.minimum_age_num, cv.minimum_age_unit, ' ||
            '   cv.maximum_age_num, cv.maximum_age_unit, ' ||
            '   d.allocation, d.intervention_model, d.primary_purpose, d.time_perspective, d.masking  ' ||
            '   from ctgov.studies s, ctgov.calculated_values cv, ctgov.designs d ' ||
            '   where s.nct_id = cv.nct_id ' ||
            '     and s.nct_id = d.nct_id  ' ||
            '     and s.nct_id in (        ' ||
              ' select distinct s.nct_id   ' ||
               ' from ctgov.studies s, ctgov.browse_conditions bc ' ||
               ' where s.study_type=''Interventional''  ' ||
                 ' and s.study_first_posted_date >= ''2007-10-01'' ' ||
                 ' and s.nct_id = bc.nct_id ' ||
                 ' and bc.downcase_mesh_term IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''mental health'') '
              ' union ' ||
              '   select distinct s.nct_id ' ||
              '   from ctgov.studies s, ctgov.keywords k ' ||
              '   where s.study_type=''Interventional'' ' ||
              '   and s.study_first_posted_date >= ''2007-10-01'' ' ||
              '   and s.nct_id = k.nct_id ' ||
              '  and k.downcase_name IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''mental health'')  ' ||
              ' union  ' ||
              '   select distinct s.nct_id  ' ||
              '   from ctgov.studies s, ctgov.conditions c  ' ||
              '   where s.study_type=''Interventional''  ' ||
              '   and s.study_first_posted_date >= ''2007-10-01''  ' ||
              '   and s.nct_id = c.nct_id  ' ||
              '   and c.downcase_name IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''mental health'')  ' ||
              '   ) ';

          EXECUTE 'CREATE OR REPLACE VIEW proj_tag.current_oncology_studies AS ' ||
            ' select distinct s.nct_id, s.start_date, s.start_date_type, s.primary_completion_date, s.primary_completion_date_type, ' ||
            '   s.acronym, s.brief_title, s.official_title, s.overall_status, s.phase, ' ||
            '   s.source, s.number_of_arms, s.enrollment, ' ||
            '   regexp_replace(s.baseline_population, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as baseline_population,  ' ||
            '   regexp_replace(s.why_stopped, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as why_stopped,  ' ||
            '   regexp_replace(s.limitations_and_caveats, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as limitations_and_caveats,  ' ||
            '   cv.number_of_facilities, cv.actual_duration, ' ||
            '   cv.were_results_reported, cv.has_us_facility, cv.has_single_facility, ' ||
            '   cv.months_to_report_results , cv.minimum_age_num, cv.minimum_age_unit, ' ||
            '   cv.maximum_age_num, cv.maximum_age_unit, ' ||
            '   d.allocation, d.intervention_model, d.primary_purpose, d.time_perspective, d.masking  ' ||
            '   from ctgov.studies s, ctgov.calculated_values cv, ctgov.designs d ' ||
            '   where s.nct_id = cv.nct_id ' ||
            '     and s.nct_id = d.nct_id  ' ||
            '     and s.nct_id in (        ' ||
              ' select distinct s.nct_id   ' ||
               ' from ctgov.studies s, ctgov.browse_conditions bc ' ||
               ' where s.study_type=''Interventional''  ' ||
                 ' and s.study_first_posted_date >= ''2007-10-01'' ' ||
                 ' and s.nct_id = bc.nct_id ' ||
                 ' and bc.downcase_mesh_term IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''oncology'') '
              ' union ' ||
              '   select distinct s.nct_id ' ||
              '   from ctgov.studies s, ctgov.keywords k ' ||
              '   where s.study_type=''Interventional'' ' ||
              '   and s.study_first_posted_date >= ''2007-10-01'' ' ||
              '   and s.nct_id = k.nct_id ' ||
              '  and k.downcase_name IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''oncology'')  ' ||
              ' union  ' ||
              '   select distinct s.nct_id  ' ||
              '   from ctgov.studies s, ctgov.conditions c  ' ||
              '   where s.study_type=''Interventional''  ' ||
              '   and s.study_first_posted_date >= ''2007-10-01''  ' ||
              '   and s.nct_id = c.nct_id  ' ||
              '   and c.downcase_name IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''oncology'')  ' ||
              '   ) ';

          EXECUTE 'CREATE OR REPLACE VIEW proj_tag.current_cardiovascular_studies AS ' ||
            ' select distinct s.nct_id, s.start_date, s.start_date_type, s.primary_completion_date, s.primary_completion_date_type, ' ||
            '   s.acronym, s.brief_title, s.official_title, s.overall_status, s.phase, ' ||
            '   s.source, s.number_of_arms, s.enrollment, ' ||
            '   regexp_replace(s.baseline_population, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as baseline_population,  ' ||
            '   regexp_replace(s.why_stopped, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as why_stopped,  ' ||
            '   regexp_replace(s.limitations_and_caveats, E''[\\n\\r\\u2028]+'', '' '', ''g'' ) as limitations_and_caveats,  ' ||
            '   cv.number_of_facilities, cv.actual_duration, ' ||
            '   cv.were_results_reported, cv.has_us_facility, cv.has_single_facility, ' ||
            '   cv.months_to_report_results , cv.minimum_age_num, cv.minimum_age_unit, ' ||
            '   cv.maximum_age_num, cv.maximum_age_unit, ' ||
            '   d.allocation, d.intervention_model, d.primary_purpose, d.time_perspective, d.masking  ' ||
            '   from ctgov.studies s, ctgov.calculated_values cv, ctgov.designs d ' ||
            '   where s.nct_id = cv.nct_id ' ||
            '     and s.nct_id = d.nct_id  ' ||
            '     and s.nct_id in (        ' ||
              ' select distinct s.nct_id   ' ||
               ' from ctgov.studies s, ctgov.browse_conditions bc ' ||
               ' where s.study_type=''Interventional''  ' ||
                 ' and s.study_first_posted_date >= ''2007-10-01'' ' ||
                 ' and s.nct_id = bc.nct_id ' ||
                 ' and bc.downcase_mesh_term IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''cardiovascular'') '
              ' union ' ||
              '   select distinct s.nct_id ' ||
              '   from ctgov.studies s, ctgov.keywords k ' ||
              '   where s.study_type=''Interventional'' ' ||
              '   and s.study_first_posted_date >= ''2007-10-01'' ' ||
              '   and s.nct_id = k.nct_id ' ||
              '  and k.downcase_name IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''cardiovascular'')  ' ||
              ' union  ' ||
              '   select distinct s.nct_id  ' ||
              '   from ctgov.studies s, ctgov.conditions c  ' ||
              '   where s.study_type=''Interventional''  ' ||
              '   and s.study_first_posted_date >= ''2007-10-01''  ' ||
              '   and s.nct_id = c.nct_id  ' ||
              '   and c.downcase_name IN (select term from proj_tag_study_characteristics.tagged_terms where tag=''cardiovascular'')  ' ||
              '   ) ';

          RETURN;
        END;
        $BODY$ LANGUAGE plpgsql STRICT;
     SQL

  end

  def down
    execute "DROP SCHEMA proj_tag CASCADE;"
  end

end
