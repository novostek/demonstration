class AddBpmInstanceToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :bpm_instance, :string
  end
end
