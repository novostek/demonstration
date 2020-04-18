class AddEmailToLead < ActiveRecord::Migration[6.0]
  def change
    add_column :leads, :email, :string
  end
end
