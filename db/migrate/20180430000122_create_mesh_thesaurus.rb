class CreateMeshThesaurus < ActiveRecord::Migration[5.2]

  def up

    execute "CREATE SCHEMA mesh_archive;"
    execute "GRANT USAGE ON SCHEMA mesh_archive to read_only;"
    execute "GRANT SELECT ON ALL TABLES IN SCHEMA mesh_archive TO read_only;"

    create_table 'mesh_archive.y2010_mesh_terms' do |t|
      t.string  'qualifier'
      t.string  'tree_number'
      t.string  'description'
      t.string  'mesh_term'
      t.string  'downcase_mesh_term'
    end

    create_table 'mesh_archive.y2016_mesh_terms' do |t|
      t.string  'qualifier'
      t.string  'tree_number'
      t.string  'description'
      t.string  'mesh_term'
      t.string  'downcase_mesh_term'
    end

    create_table 'mesh_archive.y2018_mesh_terms' do |t|
      t.string  'qualifier'
      t.string  'tree_number'
      t.string  'description'
      t.string  'mesh_term'
      t.string  'downcase_mesh_term'
    end

    create_table 'mesh_archive.y2016_mesh_headings' do |t|
      t.string  'qualifier'
      t.string  'heading'
      t.string  'subcategory'
    end

    add_index 'mesh_archive.y2010_mesh_terms', :qualifier
    add_index 'mesh_archive.y2010_mesh_terms', :description
    add_index 'mesh_archive.y2010_mesh_terms', :mesh_term
    add_index 'mesh_archive.y2010_mesh_terms', :downcase_mesh_term

    add_index 'mesh_archive.y2016_mesh_terms', :qualifier
    add_index 'mesh_archive.y2016_mesh_terms', :description
    add_index 'mesh_archive.y2016_mesh_terms', :mesh_term
    add_index 'mesh_archive.y2016_mesh_terms', :downcase_mesh_term
    add_index 'mesh_archive.y2016_mesh_headings', :qualifier

    add_index 'mesh_archive.y2018_mesh_terms', :qualifier
    add_index 'mesh_archive.y2018_mesh_terms', :description
    add_index 'mesh_archive.y2018_mesh_terms', :mesh_term
    add_index 'mesh_archive.y2018_mesh_terms', :downcase_mesh_term

  end

  def down
    execute "DROP SCHEMA mesh_archive CASCADE;"
  end
end
