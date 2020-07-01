class AddPaymentApprovalToEstimate < ActiveRecord::Migration[6.0]
  def change
    add_column :estimates, :payment_approval, :boolean
  end
end
