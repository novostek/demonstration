class ChangeUuidForClonedFrom < ActiveRecord::Migration[6.0]
  def change
    add_column :measurement_areas, :cloned_from_uuid, :uuid

    change_table :measurement_areas do |t|
      t.remove :cloned_from
      t.rename :cloned_from_uuid, :cloned_from
    end
  end
end
