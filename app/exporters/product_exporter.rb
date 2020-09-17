class ProductExporter < RailsExporter::Base
  require 'csv'

  exporter do
    column :name
    column :uuid
    column :details
    column(:product_category) {|record| record.product_category.name if record.product_category }
    column :customer_price => :currency
    column :cost_price => :currency
    column :area_covered => :numeric
    column :tax => :boolean
    column :bpm_purchase
    column(:created_at) { |record| record.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:updated_at) { |record| record.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:supplier) { |record| record.supplier.name if record.supplier }
    column(:calculation_formula) { |record| record.calculation_formula.name if record.calculation_formula }
    column(:photo) { |record| record.photo.url if record.photo }
    column :active => :boolean
  end

end