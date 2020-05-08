json.incomes do
  json.array! @year_incomes.map { |x| x[:value] }
end

json.costs do
  json.array! @year_costs.map { |x| x[:value] }
end

json.balance @balance

if @year_incomes.length > 1
  json.total_income number_to_currency(@year_incomes.map { |m| m[:value] }.reduce(0, :+), :unit => '$ ')
else
  json.total_income number_to_currency(@year_incomes.map { |m| m[:value] }.reduce(0, :+)[:value], :unit => '$ ')
end

if @year_costs.length > 1
  json.total_costs number_to_currency(@year_costs.map { |m| m[:value] }.reduce(0, :+), :unit => '$ ')
else
  json.total_costs number_to_currency(@year_costs.map { |m| m[:value] }.reduce(0, :+)[:value], :unit => '$ ')
end