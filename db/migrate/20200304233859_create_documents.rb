class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents do |t|
      t.string :name
      t.text :description
      t.text :data
      t.string :type
      t.string :sub_type

      t.timestamps
    end
  end
end
