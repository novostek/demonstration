class FinancesController < ApplicationController

  def dashboard
    credit_category_ids = TransactionAccount.get_category_ids('credit')
    cost_category_ids = TransactionAccount.get_category_ids('debit')

    @year_incomes = Transaction.get_finances(credit_category_ids)
    @year_costs = Transaction.get_finances(cost_category_ids)

    @day_incomes = Transaction.get_day_finances(credit_category_ids)
    @day_costs = Transaction.get_day_finances(cost_category_ids)
    
    # if @year_incomes.length > 1
    #   @total_income = number_to_currency(@year_incomes.reduce { |prev, cur| prev[:value]+cur[:value] }, :unit => '$ ')
    # else
    #   @total_income = number_to_currency(@year_incomes.reduce { |prev, cur| prev[:value]+cur[:value] }[:value], :unit => '$ ')
    # end

    # if @year_costs.length > 1
    #   @total_costs = number_to_currency(@year_costs.reduce { |prev, cur| prev[:value]+cur[:value] }, :unit => '$ ')
    # else
    #   @total_costs = number_to_currency(@year_costs.reduce { |prev, cur| prev[:value]+cur[:value] }[:value], :unit => '$ ')
    # end
    
  end

end
