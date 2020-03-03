# Setting.create!([
#   {namespace: "company_name", value: {"value"=>"Woffice"}},
#   {namespace: "send_grid_key", value: {"value"=>"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"}},
#   {namespace: "square_key", value: {"value"=>"EAAAEH83t1qbAPHypGll3SImNboOkHzhbVZn2XmOIq21ItYy8BXWGrRmXjRUgTaG"}},
#   {namespace: "square_app_id", value: {"value"=>"sandbox-sq0idb-g75z4FJpMVE0s9qUn7GTmQ"}},
#   {namespace: "mail_to_customer", value: {"value"=>{"send_from"=>"Customer", "template_id"=>"d-209a08276e804f778e57cefb058b52d1", "objects"=>[{"class"=>"Customer", "fields"=>[{"field"=>"nome_categoria", "sendgridkey"=>"metodo"}, {"field"=>"notes", "sendgridkey"=>"notes"}]}]}}}
# ])

10.times do
  Customer.create(
    name: Faker::Name.name,
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    category: Faker::Name.category,
    code: Faker::IDNumber.brazilian_citizen_number,
    since: Faker::Date.between(from: 2.years.ago, to: Date.today),
    document_id: Faker::IDNumber.valid
  )
end

10.times do
  Worker.create(
    name: Faker::Name.name,
    categories: Faker::Name.worker_category,
    document_id: Faker::IDNumber.valid
  )
end
