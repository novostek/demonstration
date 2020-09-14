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
    column(:price) { |record| record.current_estimate.total }
    column :status
    column(:created_at) { |record| record.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:updated_at) { |record| record.updated_at.strftime("%m/%d/%Y %H:%M") }
  end

  exporter :costs do
    # order
    column :code
    column :status
    column(:customer) { |record| record.get_current_estimate.customer.name }
    column(:sales_person) { |record| record.get_current_estimate.worker.name }
    column(:telephone) { |record| record.current_estimate.customer.get_main_phone_f || "No Phone" }
    column(:location) { |record| record.current_estimate.location }
    column(:title) { |record| record.current_estimate.title }
    column(:price) { |record| record.current_estimate.total }
    column :status
    column(:created_at) { |record| record.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:updated_at) { |record| record.updated_at.strftime("%m/%d/%Y %H:%M") }

    # products
    column(:products) { |record| record.product_purchases.select { |pp| pp.tax == false }.group_by{|pp| pp.purchase.supplier.name }.map{|k, v| [k => v.map{|pp| pp.product.name || pp.custom_title}]}.flatten.to_s }

    # taxes
    column(:taxes) { |record| record.product_purchases.select { |pp| pp.tax == true }.map{|pp| [pp.product || pp.custom_title, pp.value.to_s] }.flatten.to_s }

    # labor costs
    column(:labor_costs) {|record| record.labor_costs.map{|l| l.worker.name if l.worker}.to_s }
  end


end