class ProductPurchaseExporter < RailsExporter::Base
  require 'csv'

  exporter :dashboard_order do
    # orders
    column(:customer) { |pp| pp.purchase.order.get_current_estimate.customer.name }
    column(:ordered) { |pp| pp.purchase.order.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:code) { |pp| pp.purchase.order.code }
    column(:tax) { |pp| ActionController::Base.helpers.number_to_currency(pp.purchase.order.current_estimate.tax || 0) + ' ' + (pp.purchase.order.current_estimate.taxpayer.present? ? "(#{I18n.t "enumerize.estimate.taxpayer.#{pp.purchase.order.current_estimate.taxpayer}"})" : '') }
    column(:total_cost) { |pp| pp.purchase.order.total_cost.to_s }
    column(:status_order) { |pp| pp.purchase.order.status_text }

    # product purchase
    column(:product) { |pp| pp.product.present? ? pp.product.name : pp.custom_title }
    column(:supplier) { |pp| pp.purchase.supplier.present? ? pp.purchase.supplier.name : 'No Supplier' }
    column :quantity
    column(:price) { |pp| pp.unity_value.to_f }
    column(:subtotal) { |pp| pp.value.to_f }
    column(:deliverd) { |pp| pp.status.delivered? ? pp.updated_at.strftime("%m/%d/%Y") : '' }
    column(:status_product) { |pp| pp.status_text }
  end


end