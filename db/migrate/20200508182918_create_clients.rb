class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients, id: :uuid do |t|
      t.string :name
      t.string :tenant_name

      t.timestamps
    end
  end
end
