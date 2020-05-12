class FinancesController < ApplicationController

  def dashboard
    @year_incomes = Transaction.get_finances('income')
    @year_costs = Transaction.get_finances('cost')

    @day_incomes = Transaction.get_day_finances('income')
    @day_costs = Transaction.get_day_finances('cost')

    @balance = []

    @year_incomes.each do |income|
      cost = @year_costs.detect { |c| c[:month] == income[:month] }
      if cost.present? and income[:month] == cost[:month]
        @balance.push({
          :month => income[:month],
          :value => income[:value] - cost[:value]
        })
      end
    end

    @year_costs = @year_costs.map { |cost| {
      :month => cost[:month],
      :value => cost[:value] * -1
    } }

    @total_balance = @balance.reduce { |sum, num| sum[:value] + num[:value] }

    @receivables = Transaction.get_amount_of_receivables
    @overdue = Transaction.get_amount_of_overdue

    @material_costs = Transaction.get_material_costs
    @labor_costs = Transaction.get_labor_costs

    @new_orders = Order.get_new_orders_count
    @finished_orders = Order.get_finished_orders_count
    @cancelled_orders = Order.get_cancelled_orders_count
    @latest_orders = Order.get_latest_orders 4

    @count_new_customers = Customer.count_new_customers
    @total_customers = Customer.count
    @recent_customers = Customer.get_recent_customers 3
  end

end
