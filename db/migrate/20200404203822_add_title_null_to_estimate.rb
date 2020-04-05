class AddTitleNullToEstimate < ActiveRecord::Migration[6.0]
  def change
    change_column_null :estimates, :title, true
  end
end
