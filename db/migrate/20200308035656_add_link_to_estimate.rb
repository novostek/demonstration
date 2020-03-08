class AddLinkToEstimate < ActiveRecord::Migration[6.0]
  def change
    add_column :estimates, :link, :text
  end
end
