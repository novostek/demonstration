begin
User.create!([

  {email: "gabrielvash@gmail.com", password:"123456", password_confirmation: "123456", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, name: "Gabriel Santos", active: true},
])
rescue
end
begin
Setting.create!([
  {namespace: "company_name", value: {"value"=>"Woffice"}},
  {namespace: "client_end_order", value: {"value"=>true}},
  {namespace: "send_grid_key", value: {"value"=>"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"}},
  {namespace: "square_key", value: {"value"=>"EAAAEH83t1qbAPHypGll3SImNboOkHzhbVZn2XmOIq21ItYy8BXWGrRmXjRUgTaG"}},
  {namespace: "mail_to_customer", value: {"value"=>{"send_from"=>"Customer", "template_id"=>"d-209a08276e804f778e57cefb058b52d1", "objects"=>[{"class"=>"Customer", "fields"=>[{"field"=>"nome_categoria", "sendgridkey"=>"metodo"}, {"field"=>"notes", "sendgridkey"=>"notes"}]}]}}},
  {namespace: "order_need_sign", value: {"value"=>false}},
  {namespace: "authenticity_token", value: {"value"=>"Me5mPkAi34kYZZ8mpbk9CvG1y0Li5fjy1Lezu8UwIg6wtIkpcjYX43n5EZdjABNQiL9dUIKf7M+1RjnthdrrUw=="}},
  {namespace: "company_full_name", value: {"value"=>"Face of Wood Flooring, INC."}},
  {namespace: "company_address", value: {"value"=>"2450 W Sample Rd, Ste 12, Pompano Beach, FL, 33073"}},
  {namespace: "company_phone", value: {"value"=>"(954) 663-8000"}},
  {namespace: "company_email", value: {"value"=>"info@faceofwood.com"}},
  {namespace: "logo", value: {"value"=>"https://i.ibb.co/sVQ03Sk/Whats-App-Image-2020-04-02-at-12-51-26.jpg"}},
  {namespace: "square_app_id", value: {"value"=>"sq0idp-6o0iL_Vn1ztjynF6WlRArg"}},
  {namespace: "estimate_notes", value: {"value"=>"<p style=\"box-sizing: inherit; font-family: Muli, sans-serif; color: rgb(65, 65, 65); font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255);\"><strong style=\"box-sizing: inherit; font-weight: 700;\"><u style=\"box-sizing: inherit;\">Payment Terms</u></strong>: for material only, 100% of the estimate is due before we &nbsp;can order the material. For material and labor, the material cost or 50% of the project total, whichever is greater, is due upon signing and the remaining balance is due at the same day the job is completed. If for any reason the job is delayed due to material shortage, 40% should be charged at the same day the existing material is used and only 10% of the total could be withhold until the rest of the material is delivered and installed.</p><p style=\"box-sizing: inherit; font-family: Muli, sans-serif; color: rgb(65, 65, 65); font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255);\"><br></p><p style=\"box-sizing: inherit; font-family: Muli, sans-serif; color: rgb(65, 65, 65); font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255);\"><strong style=\"box-sizing: inherit; font-weight: 700;\"><u style=\"box-sizing: inherit;\">Warranty</u></strong>: We offer 1-year warranty on installation. We are not responsible for damage to flooring caused by water or moisture intrusion from walls, windows, doors, apertures, not from poor drainage and changes in sub-floor moisture content not present at time of pre-installation test done with a concrete moisture meter. The moisture test scale goes from 1 to 6, being acceptable readings from 1 to 4. For readings from 5 to 6 extra moisture protection/barrier is required. Should customer request more extensive moisture testing (E.G. Calcium Chloride test or other), it is their responsibility to request this in writing at their expense.</p><p style=\"box-sizing: inherit; font-family: Muli, sans-serif; color: rgb(65, 65, 65); font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255);\"><br></p><p style=\"box-sizing: inherit; font-family: Muli, sans-serif; color: rgb(65, 65, 65); font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255);\"><strong style=\"box-sizing: inherit; font-weight: 700;\"><u style=\"box-sizing: inherit;\">Material Return</u></strong>: if client requests to change or return of any material purchased for this contract, a 25% restocking fee and/or shipping fees will be charged. The remaining balance should be paid in full and Face of Wood will mail a check with the credit related to return after material fully returned to distributor.</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>"}},
  {namespace: "square_oauth_secret", value: {"value"=>"sq0csp-SKgwPz6MYCyEn17WsJn3EZcqbJqW7TtqJUDpfVM7MCA"}},
  {namespace: "take_photo", value: {"value"=>true}},
  {namespace: "default_url", value: {"value"=>"https://woodoffice.herokuapp.com"}},
  {namespace: "hidden_measurement_fields", value: {"value"=>{"width"=>true, "length"=>true, "height"=>false, "square_feet"=>false}}},
  {namespace: "url_app", value: {"value"=>"https://woodoffice.herokuapp.com"}},
  {namespace: "send_square_mail_text", value: {"value"=>"<p>Pay Text <strong>example</strong></p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>"}},
  {namespace: "send_invoice_mail_text", value: {"value"=>"<p>Text example</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>"}},
  {namespace: "send_document_mail_text", value: {"value"=>"<p>Text example</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>"}},
  {namespace: "sign_order_mail_text", value: {"value"=>"<p>Sign submitted document</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>"}}
])
Profile.create!([
  {name: "Administrator", description: " System administrator profile", status: "t", permissions: {"CustomersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}, "CalculationFormulasController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "DocumentFilesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductCategoriesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "SettingsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "SuppliersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "new_contact"=>"true"}}},
  {name: "Finance", description: " Financial access profile", status: "t", permissions: {"CustomersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "search_by_phone"=>"true", "show"=>"true", "update"=>"true"}, "CalculationFormulasController"=>{"cache_globals_settings"=>"true", "calculate_product_qty_lw"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "DocumentFilesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductCategoriesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "SuppliersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}}},
  {name: "Worker", description: " Worker profile", status: "t", permissions: {"ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "load_notes"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}}},
  {name: "Purchase", description: "Purchase profiles", status: "t", permissions: {"CustomersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "home"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "search_by_phone"=>"true", "search_customers"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "DocumentFilesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "ProductCategoriesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "ProductsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "SuppliersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}}}
])
Menu.create!([
  {active: true, icon: "assignment", name: "Leads", url: "/leads", ancestry: nil, position: 1},
  {active: true, icon: "face", name: "Customer", url: "/customers", ancestry: nil, position: 4},
  {active: true, icon: "business_center", name: "Workers", url: "/workers", ancestry: nil, position: 5},
  {active: true, icon: "assignment_turned_in", name: "Estimates", url: "/estimates", ancestry: nil, position: 2},
  {active: true, icon: "event_note", name: "Schedules", url: "/schedules", ancestry: nil, position: 6},
  {active: true, icon: "assignment_ind", name: "Orders", url: "/orders", ancestry: nil, position: 3},
  {active: true, icon: "settings", name: "Configuration", url: "#", ancestry: nil, position: 10},
  {active: true, icon: "local_atm", name: "Calculation Formula", url: "/calculation_formulas", ancestry: "7", position: 1},
  {active: true, icon: "shopping_basket", name: "Product Categories", url: "/product_categories", ancestry: "7", position: 2},
  {active: true, icon: "shopping_cart", name: "Products", url: "/products", ancestry: "7", position: 3},
  {active: true, icon: "credit_card", name: "Transaction Categories", url: "/transaction_categories", ancestry: "7", position: 6},
  {active: true, icon: "chrome_reader_mode", name: "Transactions Accounts", url: "/transaction_accounts", ancestry: "7", position: 5},
  {active: true, icon: "build", name: "Setup", url: "#", ancestry: nil, position: 11},
  {active: true, icon: "view_list", name: "Menu", url: "/menus", ancestry: "13", position: nil},
  {active: true, icon: "person_add", name: "Users", url: "/users", ancestry: "13", position: nil},
  {active: true, icon: "assignment_ind", name: "Profile", url: "/profiles", ancestry: "13", position: nil},

  {active: true, icon: "description", name: "Documents", url: "/documents", ancestry: nil, position: 9},
  {active: true, icon: "local_grocery_store", name: "Suppliers", url: "/suppliers", ancestry: nil, position: 8},
  {active: true, icon: "monetization_on", name: "Transactions", url: "/transactions", ancestry: nil, position: 7},
  {active: true, icon: "add_to_queue", name: "Settings", url: "/settings", ancestry: nil, position: 9}
])
ProfileMenu.create!([
  {menu_id: 1, profile_id: 1},
  {menu_id: 7, profile_id: 1},
  {menu_id: 8, profile_id: 1},
  {menu_id: 9, profile_id: 1},
  {menu_id: 10, profile_id: 1},
  {menu_id: 11, profile_id: 1},
  {menu_id: 13, profile_id: 1},
  {menu_id: 15, profile_id: 1},
  {menu_id: 18, profile_id: 1},
  {menu_id: 21, profile_id: 1},
  {menu_id: 23, profile_id: 1},
  {menu_id: 24, profile_id: 1},
  {menu_id: 25, profile_id: 1},
  {menu_id: 26, profile_id: 1},
  {menu_id: 27, profile_id: 1},
  {menu_id: 29, profile_id: 1},
  {menu_id: 30, profile_id: 1},
  {menu_id: 31, profile_id: 1},
  {menu_id: 1, profile_id: 2},
  {menu_id: 1, profile_id: 4},
  {menu_id: 11, profile_id: 2},
  {menu_id: 11, profile_id: 4},
  {menu_id: 13, profile_id: 2},
  {menu_id: 13, profile_id: 4},
  {menu_id: 3, profile_id: 1},
  {menu_id: 3, profile_id: 2},
  {menu_id: 31, profile_id: 2},
  {menu_id: 31, profile_id: 3},
  {menu_id: 31, profile_id: 4},
  {menu_id: 32, profile_id: 1}
])
ProfileUser.create!([
  {user_id: 1, profile_id: 1},
])
rescue
end
