class FinancesController < ApplicationController

  def dashboard
    @year_incomes = Transaction.get_finances('income')
    @year_costs = Transaction.get_finances('cost')

    @day_incomes = Transaction.get_day_finances('income')
    @day_costs = Transaction.get_day_finances('cost')
    #binding.pry

    @balance = []
    beginning_of_month = Date.today.beginning_of_month
    (0..11).map{|a| a}.reverse.map do |number|
      month = (beginning_of_month - number.months).month
      income = @year_incomes.detect { |i| i[:month_n] == month }
      cost = @year_costs.detect { |c| c[:month_n] == month }
      if income.present?
        income_value = income[:value]
        month_name = income[:month]
      else
        income_value = 0
      end

      if cost.present?
        cost_value = cost[:value]
        month_name = cost[:month]
      else
        cost_value = 0
      end

      if income.present? or cost.present?
        @balance.push({
                          :month => month_name,
                          :value => income_value - (cost_value * -1)
                      })
      end
    end

    @year_costs = @year_costs.map { |cost| {
      :month => cost[:month],
      :value => cost[:value] * -1
    } }
    @total_balance = {value: @balance.sum {|el| el[:value]} }
    @receivables = Transaction.get_amount_of_receivables
    @overdue = Transaction.get_amount_of_overdue

    @material_costs = Transaction.get_material_costs
    @labor_costs = Transaction.get_labor_costs

    @new_orders = Order.get_new_orders_count
    @lasted_orders = Order.get_new_orders_count
    @new_leads = Lead.get_new_leads_count
    @new_estimates = Estimate.get_new_estimates_count
    @finished_orders = Order.get_finished_orders_count
    @cancelled_orders = Order.get_cancelled_orders_count
    @latest_orders = Order.get_latest_orders 4

    @count_new_customers = Customer.count_new_customers
    @total_customers = Customer.count
    @recent_customers = Customer.get_recent_customers 3

    begin
      value= @total_balance[:value]
    rescue
      @total_balance= {value: 0}
    end

    if @total_balance.blank?
      @total_balance= {value: 0}
    end

    begin
      @conversion_rate = ((@lasted_orders) / @new_leads * 100).round(2)
    rescue
      @conversion_rate = 0
    end
  end

  def dashboard_orders
    @q = Order.ransack(params[:q])
    orders = @q.result.includes(:current_estimate, :customer, :purchases, {purchases: [:supplier, :product_purchases, {product_purchases: [:product, :notes, :document_files]}]} ).ordenation_by(params[:sort_by]).uniq
    @orders = Kaminari.paginate_array(orders).page(params[:page]).per(4)

    @suppliers = Supplier.all.map {|s| [s.name, nil]}.to_h.to_json
    @workers = Worker.all.map {|w| [w.name, nil]}.to_h.to_json
    #@products = Product.all.map {|p| [p.name, nil]}.to_h.to_json
    @products = ProductPurchase.where(tax: false).select{|pp| pp.custom_title.present? }.map {|p| [p.custom_title, nil]}.to_h.to_json
    @customers = Customer.all.map {|c| [c.name, nil]}.to_h.to_json
  end

end
