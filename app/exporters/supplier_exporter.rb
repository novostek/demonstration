class SupplierExporter < RailsExporter::Base
  require 'csv'

  exporter do
    column :name
    column :description
    column(:created_at) { |record| record.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:updated_at) { |record| record.updated_at.strftime("%m/%d/%Y %H:%M") }
    column :active => :boolean
  end

end