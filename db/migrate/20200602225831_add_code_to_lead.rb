class AddCodeToLead < ActiveRecord::Migration[6.0]
  def change
    add_column :leads, :code, :string
    add_index :leads, :code
  end
end
