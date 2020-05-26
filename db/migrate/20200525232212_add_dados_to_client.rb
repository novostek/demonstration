class AddDadosToClient < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :code, :string
    add_column :clients, :company_name, :string
    add_column :clients, :email, :string
  end
end
