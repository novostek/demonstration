class CreateWorkers < ActiveRecord::Migration[6.0]
  def change
    create_table :workers, id: :uuid do |t|
      t.string :name
      t.text :photo
      t.string :document_id
      t.string :categories

      t.timestamps
    end
  end
end
