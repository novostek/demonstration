class TransactionExporter < RailsExporter::Base
  require 'csv'

  exporter do
    column(:source) { |record| record.payment_method }
    column(:title) { |record| record.title }
    column(:origin) {|record| record.order.code if record.order }
    column(:category) { |record| record.transaction_category.name if record.transaction_category }
    column(:account) { |record| record.transaction_account.name if record.transaction_account }
    column(:due) { |record| record.due.strftime("%m/%d/%Y") if record.due }
    column(:effective) { |record| record.effective.strftime("%m/%d/%Y %H:%M") if record.effective }
    column :status
    column(:created_at) { |record| record.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:updated_at) { |record| record.updated_at.strftime("%m/%d/%Y %H:%M") }
    column :value => :currency
  end

end