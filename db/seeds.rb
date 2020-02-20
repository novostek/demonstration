Setting.create!([
  {namespace: "company_name", value: {"value"=>"Woffice"}},
  {namespace: "mail_to_customer", value: {"value"=>{"send_from"=>"Customer", "template_id"=>"d-209a08276e804f778e57cefb058b52d1", "objects"=>[{"class"=>"Customer", "fields"=>[{"field"=>"name", "sendgridkey"=>"customer_name"}, {"field"=>"category", "sendgridkey"=>"customer_category"}, {"field"=>"since", "sendgridkey"=>"customer_since"}, {"field"=>"code", "sendgridkey"=>"customer_code"}]}]}}},
  {namespace: "send_grid_key", value: {"value"=>"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"}}
])
