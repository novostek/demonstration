class AddPublicNoteToNotes < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :public_note, :boolean
  end
end
