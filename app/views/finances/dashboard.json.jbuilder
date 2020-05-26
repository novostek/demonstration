json.incomes @year_incomes.each do |income|
  json.month_index income[:month_n]
  json.month income[:month]
  json.value income[:value]
end

json.costs @year_costs.each do |cost|
  json.month_index cost[:month_n]
  json.month cost[:month]
  json.value cost[:value]
end

json.balance @balance
json.total_balance @total_balance

# if @year_incomes.length > 1
json.total_income number_to_currency(@year_incomes.map { |m| m[:value] }.reduce(0, :+), :unit => '$ ')
# else
#   json.total_income number_to_currency(@year_incomes.map { |m| m[:value] }.reduce(0, :+)[:value], :unit => '$ ')
# end

# if @year_costs.length > 1
json.total_costs number_to_currency(@year_costs.map { |m| m[:value] }.reduce(0, :+), :unit => '$ ')
# else
  # json.total_costs number_to_currency(@year_costs.map { |m| m[:value] }.reduce(0, :+)[:value], :unit => '$ ')
# end