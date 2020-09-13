class CustomerExporter < RailsExporter::Base
  require 'csv'

  exporter do
    column :name
    column :category
    column :document_id
    column :since
    column :code
    column :birthdate => :date
    column :created_at => :timestamp
    column :updated_at => :timestamp
    column :bpm_instance
    column :square_id
  end

end