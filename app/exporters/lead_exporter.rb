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
    column :date do |record|
      record.created_at.strftime("%m/%d/%Y %H:%M:%S")
    end
    column(:created_at) do |record|
      record.created_at.strftime("%m/%d/%Y %H:%M:%S")
    end
    column(:updated_at) do |record|
      record.updated_at.strftime("%m/%d/%Y %H:%M:%S")
    end
  end

end