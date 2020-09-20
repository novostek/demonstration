class ProductPurchaseExporter < RailsExporter::Base
  require 'csv'

  exporter do
    column(:created_at) { |record| record.created_at.strftime("%m/%d/%Y %H:%M") }
    column(:updated_at) { |record| record.updated_at.strftime("%m/%d/%Y %H:%M") }
  end

  exporter :dashboard_order do
    column(:customer) { |record| record.purchase.order.get_current_estimate.customer.name }
    column(:ordered) { |record| record.purchase.order.created_at.strftime("%m/%d/%Y %H:%M") }
    column :code
    column(:tax) { |record| ActionController::Base.helpers.number_to_currency(record.purchase.order.current_estimate.tax || 0) + ' ' + (record.purchase.order.current_estimate.taxpayer.present? ? "(#{I18n.t "enumerize.estimate.taxpayer.#{record.purchase.order.current_estimate.taxpayer}"})" : '') }
    column(:total_cost) { |record| record.purchase.order.total_cost.to_s }
    column(:status_order) { |record| record.purchase.order.status_text }
    #column ''

    #product_purchases = order.product_purchases.select { |pp| pp.tax == false }
    #
    #if product_purchases.any?
    #  product_purchases.each do |pp|
    #    sheet.add_row [
    #                      order.customer.name,
    #                      order.created_at.to_s,
    #                      order.code,
    #                      order.current_estimate.tax || 0,
    #                      order.get_current_estimate.total,
    #                      order.status_text,
    #                      '',
    #                      pp.product || pp.custom_title,
    #                      pp.purchase.supplier || 'No Supplier',
    #                      pp.quantity,
    #                      pp.unity_value.to_f,
    #                      pp.value.to_f,
    #                      pp.status.delivered? ? pp.updated_at.strftime("%m/%d/%Y") : '',
    #                      pp.status_text
    #                  ]
    #  end
    #else
    #  sheet.add_row [
    #                    order.customer.name,
    #                    order.created_at.to_s,
    #                    order.code,
    #                    order.current_estimate.tax || 0,
    #                    order.get_current_estimate.total,
    #                    order.status_text,
    #                    '',
    #                    '',
    #                    '',
    #                    '',
    #                    '',
    #                    '',
    #                    '',
    #                    ''
    #                ]
    #end
  end


end