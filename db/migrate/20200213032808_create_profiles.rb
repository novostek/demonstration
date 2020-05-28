class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles, id: :uuid do |t|
      t.string :name
      t.string :description
      t.string :permissions
      t.string :status

      t.timestamps
    end
  end
end
