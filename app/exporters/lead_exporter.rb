class LeadExporter < RailsExporter::Base
  require 'csv'

  exporter do
    column(:customer) { |record| record.customer.name }
    column :via
    column :description
    column :status
    column :phone
    column :email
    column :code
    column(:date) { |record| record.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:created_at) { |record| record.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:updated_at) { |record| record.updated_at.strftime("%m/%d/%Y %H:%M") }
  end

end