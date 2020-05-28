class AddPwdToClient < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :pwd, :string
  end
end
