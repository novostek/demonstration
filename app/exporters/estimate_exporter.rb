class EstimateExporter < RailsExporter::Base
  require 'csv'

  exporter do
    column :code
    column :title
    column(:sales_person) { |record| record.worker.name }
    column :status
    column :description
    column :location
    column :latitude
    column :longitude
    column :category
    column(:order) { |record| record.order.code }
    column :price => :currency
    column :tax => :currency
    column(:tax_calculation) { |record| record.calculation_formula.name if record.calculation_formula }
    column(:lead) { |record| record.lead.customer.name }
    column :bpmn_instance
    column :current => :boolean
    column :total => :currency
    column :link
    column :taxpayer
    column :payment_approval => :boolean
    column :discount
    column(:created_at) { |record| record.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:updated_at) { |record| record.updated_at.strftime("%m/%d/%Y %H:%M") }
  end

end