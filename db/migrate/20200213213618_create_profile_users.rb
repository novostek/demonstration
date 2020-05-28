class CreateProfileUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :profile_users, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :profile, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
