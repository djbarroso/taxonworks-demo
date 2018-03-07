class TweakGeographicAreas9 < ActiveRecord::Migration[4.2]
  def change

    add_column :geographic_areas, :created_by_id, :integer, index: true
    add_column :geographic_areas, :updated_by_id, :integer, index: true
    add_column :geographic_areas, :project_id, :integer, index: true

  end
end
