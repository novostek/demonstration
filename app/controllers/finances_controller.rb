class FinancesController < ApplicationController

  def dashboard
    credit_category_ids = TransactionAccount.get_category_ids('credit')
    cost_category_ids = TransactionAccount.get_category_ids('debit')

    @year_incomes = Transaction.get_finances(credit_category_ids)
    @year_costs = Transaction.get_finances(cost_category_ids)

    @day_incomes = Transaction.get_day_finances(credit_category_ids)
    @day_costs = Transaction.get_day_finances(cost_category_ids)

    @balance = [@year_incomes, @year_costs].transpose.map { |b| b.map { |x| {
      :month => x[:month],
      :value => x[:value]
    } }.reduce { |sum, num| {
      :month => num[:month],
      :value => sum[:value] + num[:value]
    } } }

    @total_balance = @balance.reduce { |sum, num| sum[:value] + num[:value] }
    
  end

end
