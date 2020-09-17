class CustomerExporter < RailsExporter::Base
  require 'csv'

  exporter do
    column :name
    column :category
    column :document_id
    column :since
    column :code
    column :birthdate => :date
    column(:created_at) { |record| record.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:updated_at) { |record| record.updated_at.strftime("%m/%d/%Y %H:%M") }
    column :bpm_instance
    column :square_id
  end

end