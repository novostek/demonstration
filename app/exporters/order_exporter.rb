class OrderExporter < RailsExporter::Base
  require 'csv'

  exporter do
    column :code
    column :status
    column(:customer) { |record| record.get_current_estimate.customer.name }
    column(:sales_person) { |record| record.get_current_estimate.worker.name }
    column(:telephone) { |record| record.current_estimate.customer.get_main_phone_f || "No Phone" }
    column(:location) { |record| record.current_estimate.location }
    column(:title) { |record| record.current_estimate.title }

    column(:cost) { |record| record.total_cost.to_s }
    column(:price) { |record| record.get_current_estimate.total }
    column(:received) { |record| record.transactions.where(status: :paid).sum(:value) }
    column(:profit) { |record| record.current_estimate.get_total_value - (record.total_cost || 0) }
    column(:tax) { |record| ActionController::Base.helpers.number_to_currency(record.current_estimate.tax || 0) + ' ' + (record.current_estimate.taxpayer.present? ? "(#{I18n.t "enumerize.estimate.taxpayer.#{record.current_estimate.taxpayer}"})" : '')  }

    column(:created_at) { |record| record.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:updated_at) { |record| record.updated_at.strftime("%m/%d/%Y %H:%M") }
  end

end