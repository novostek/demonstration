json.incomes do
  json.array! @year_incomes.map { |x| x[:value] }
end

json.costs do
  json.array! @year_costs.map { |x| x[:value] }
end

if @year_incomes.length > 1
  json.total_income number_to_currency(@year_incomes.reduce { |prev, cur| prev[:value]+cur[:value] }, :unit => '$ ')
else
  json.total_income number_to_currency(@year_incomes.reduce { |prev, cur| prev[:value]+cur[:value] }[:value], :unit => '$ ')
end

if @year_costs.length > 1
  json.total_costs number_to_currency(@year_costs.reduce { |prev, cur| prev[:value]+cur[:value] }, :unit => '$ ')
else
  json.total_costs number_to_currency(@year_costs.reduce { |prev, cur| prev[:value]+cur[:value] }[:value], :unit => '$ ')
end