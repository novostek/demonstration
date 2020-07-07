# == Schema Information
#
# Table name: public.clients
#
#  id           :uuid             not null, primary key
#  code         :string
#  company_name :string
#  email        :string
#  name         :string
#  pwd          :string
#  tenant_name  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Client < ApplicationRecord
  after_create :create_tenant

  def create_tenant
    Apartment::Tenant.create(self.tenant_name)

    Apartment::Tenant.switch(self.tenant_name) do
      # ...

      begin
        user = User.create(email: self.email, password:self.pwd, password_confirmation: self.pwd, reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, name: self.company_name, active: true )
      rescue
      end
      begin
        Setting.create!([
                            {namespace: "upload_dir", value: {"value"=>self.tenant_name}},
                            {namespace: "company_name", value: {"value"=>self.company_name}},
                            {namespace: "client_end_order", value: {"value"=>true}},
                            {namespace: "send_grid_key", value: {"value"=>""}},
                            {namespace: "square_key", value: {"value"=>""}},
                            {namespace: "mail_to_customer", value: {"value"=>{"send_from"=>"Customer", "template_id"=>"d-209a08276e804f778e57cefb058b52d1", "objects"=>[{"class"=>"Customer", "fields"=>[{"field"=>"nome_categoria", "sendgridkey"=>"metodo"}, {"field"=>"notes", "sendgridkey"=>"notes"}]}]}}},
                            {namespace: "order_need_sign", value: {"value"=>false}},
                            {namespace: "authenticity_token", value: {"value"=>"Me5mPkAi34kYZZ8mpbk9CvG1y0Li5fjy1Lezu8UwIg6wtIkpcjYX43n5EZdjABNQiL9dUIKf7M+1RjnthdrrUw=="}},
                            {namespace: "company_full_name", value: {"value"=>self.company_name}},
                            {namespace: "company_address", value: {"value"=>""}},
                            {namespace: "company_phone", value: {"value"=>""}},
                            {namespace: "company_email", value: {"value"=>self.email}},
                            {namespace: "logo", value: {"value"=>""}},
                            {namespace: "square_app_id", value: {"value"=>"sq0idp-6o0iL_Vn1ztjynF6WlRArg"}},
                            {namespace: "estimate_notes", value: {"value"=>""}},
                            {namespace: "square_oauth_secret", value: {"value"=>"sq0csp-SKgwPz6MYCyEn17WsJn3EZcqbJqW7TtqJUDpfVM7MCA"}},
                            {namespace: "take_photo", value: {"value"=>true}},
                            {namespace: "default_url", value: {"value"=>"https://#{self.tenant_name}.#{ENV["DOMAIN_URL"]}"}},
                            {namespace: "hidden_measurement_fields", value: {"value"=>{"width"=>true, "length"=>true, "height"=>false, "square_feet"=>false}}},
                            {namespace: "url_app", value: {"value"=>"https://#{self.tenant_name}.#{ENV["DOMAIN_URL"]}"}},
                            {namespace: "send_square_mail_text", value: {"value"=>"<p>Pay Text <strong>example</strong></p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>"}},
                            {namespace: "send_invoice_mail_text", value: {"value"=>"<p>Text example</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>"}},
                            {namespace: "send_document_mail_text", value: {"value"=>"<p>Text example</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>"}},
                            {namespace: "sign_order_mail_text", value: {"value"=>"<p>Sign submitted document</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>"}}
                        ])
        profile_admin = Profile.create( name: "Administrator", description: " System administrator profile", status: "t", permissions: {"CustomersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}, "CalculationFormulasController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "DocumentFilesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductCategoriesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "SettingsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "SuppliersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "new_contact"=>"true"}})
        profile_finance = Profile.create( name: "Finance", description: " Financial access profile", status: "t", permissions: {"CustomersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "search_by_phone"=>"true", "show"=>"true", "update"=>"true"}, "CalculationFormulasController"=>{"cache_globals_settings"=>"true", "calculate_product_qty_lw"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "DocumentFilesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductCategoriesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "SuppliersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}})
        profile_worker = Profile.create(name: "Worker", description: " Worker profile", status: "t", permissions: {"ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "load_notes"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}})
        profile_purchase = Profile.create( name: "Purchase", description: "Purchase profiles", status: "t", permissions: {"CustomersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "home"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "search_by_phone"=>"true", "search_customers"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "DocumentFilesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "ProductCategoriesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "ProductsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "SuppliersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}})



        customer = Menu.create(active: true, icon: "face", name: "Customers", url: "/customers", ancestry: nil, position: 4)
        workers = Menu.create(active: true, icon: "business_center", name: "Workers", url: "/workers", ancestry: nil, position: 5)
        estimates = Menu.create(active: true, icon: "assignment_turned_in", name: "Estimates", url: "/estimates", ancestry: nil, position: 2)
        schedules = Menu.create(active: true, icon: "event_note", name: "Schedules", url: "/schedules", ancestry: nil, position: 6)
        orders = Menu.create(active: true, icon: "assignment_ind", name: "Orders", url: "/orders", ancestry: nil, position: 3)
        leads = Menu.create(active: true, icon: "assignment", name: "Leads", url: "/leads/new", ancestry: nil, position: 1)
        configuration = Menu.create(active: true, icon: "settings", name: "Settings", url: "#", ancestry: nil, position: 10)
        settings = Menu.create(active: true, icon: "build", name: "System Configuration", url: "/settings", parent: configuration, position: 1)
        calculation_formula = Menu.create(active: true, icon: "local_atm", name: "Calculation Formula", url: "/calculation_formulas", parent: configuration, position:2)
        documents = Menu.create(active: true, icon: "description", name: "Documents", url: "/documents", parent: configuration, position: 3)
        security = Menu.create(active: true, icon: "security", name: "Security", url: "#", parent: configuration, position: 4)
        portifolio = Menu.create(active: true, icon: "chrome_reader_mode", name: "Portfolio", url: "#", ancestry: nil, position: 8)
        products = Menu.create(active: true, icon: "local_grocery_store", name: "Products", url: "/products", parent: portifolio, position: 1)
        suppliers = Menu.create(active: true, icon: "local_shipping", name: "Suppliers", url: "/suppliers", parent: portifolio, position: 2)
        produc_category = Menu.create(active: true, icon: "widgets", name: "Categories", url: "/product_categories", parent: portifolio, position: 3)
        finances = Menu.create(active: true, icon: "monetization_on", name: "Finances", url: "#", ancestry: nil, position: 6)
        transactions = Menu.create(active: true, icon: "monetization_on", name: "Transactions", url: "/transactions", parent: finances, position: 1)
        transaction_accounts = Menu.create(active: true, icon: "account_balance_wallet", name: "Accounts", url: "/transaction_accounts", parent: finances, position: 2)
        transaction_categories = Menu.create( active: true, icon: "donut_small", name: "Categories", url: "/transaction_categories", parent: finances, position: 3)


        users = Menu.create(active: true, icon: "person_add", name: "Users", url: "/users", parent: security, position: 1)
        profile = Menu.create(active: true, icon: "person_pin", name: "Profile", url: "/profiles", parent: security, position: 2)
        menus = Menu.create(active: true, icon: "view_list", name: "Menu Access", url: "/menus", parent: security, position: 3)
        

        ProfileMenu.create!([
                                #perfil administrator

                                {menu_id: customer.id, profile_id: profile_admin.id},
                                {menu_id: workers.id, profile_id: profile_admin.id},
                                {menu_id: estimates.id, profile_id: profile_admin.id},
                                {menu_id: schedules.id, profile_id: profile_admin.id},
                                {menu_id: orders.id, profile_id: profile_admin.id},
                                {menu_id: leads.id, profile_id: profile_admin.id},
                                {menu_id: configuration.id, profile_id: profile_admin.id},
                                {menu_id: settings.id, profile_id: profile_admin.id},
                                {menu_id: calculation_formula.id, profile_id: profile_admin.id},
                                {menu_id: documents.id, profile_id: profile_admin.id},
                                {menu_id: security.id, profile_id: profile_admin.id},
                                {menu_id: menus.id, profile_id: profile_admin.id},
                                {menu_id: users.id, profile_id: profile_admin.id},
                                {menu_id: profile.id, profile_id: profile_admin.id},
                                {menu_id: portifolio.id, profile_id: profile_admin.id},
                                {menu_id: products.id, profile_id: profile_admin.id},
                                {menu_id: suppliers.id, profile_id: profile_admin.id},
                                {menu_id: produc_category.id, profile_id: profile_admin.id},
                                {menu_id: finances.id, profile_id: profile_admin.id},
                                {menu_id: transactions.id, profile_id: profile_admin.id},
                                {menu_id: transaction_accounts.id, profile_id: profile_admin.id},
                                {menu_id: transaction_categories.id, profile_id: profile_admin.id},


                                #perfil finance
                                {menu_id: customer.id, profile_id: profile_finance.id},
                                {menu_id: leads.id, profile_id: profile_finance.id},
                                {menu_id: orders.id, profile_id: profile_finance.id},
                                {menu_id: workers.id, profile_id: profile_finance.id},
                                {menu_id: estimates.id, profile_id: profile_finance.id},
                                {menu_id: finances.id, profile_id: profile_finance.id},
                                {menu_id: transactions.id, profile_id: profile_finance.id},
                                {menu_id: transaction_categories.id, profile_id: profile_admin.id},
                                {menu_id: transaction_accounts.id, profile_id: profile_admin.id},

                                #perfil Worker
                                {menu_id: estimates.id, profile_id: profile_worker.id},

                                #Perfil purchase
                                {menu_id: customer.id, profile_id: profile_purchase.id},
                                {menu_id: workers.id, profile_id: profile_purchase.id},
                                {menu_id: estimates.id, profile_id: profile_purchase.id},
                                {menu_id: schedules.id, profile_id: profile_purchase.id},
                                {menu_id: orders.id, profile_id: profile_purchase.id},
                                {menu_id: leads.id, profile_id: profile_purchase.id},
                                {menu_id: portifolio.id, profile_id: profile_purchase.id},
                                {menu_id: products.id, profile_id: profile_purchase.id}

                            ])
        ProfileUser.create(user_id: user.id, profile_id: profile_admin.id)

          #defautl documents
        Document.create(name: "Material Delivery",doc_type: :estimate,sub_type: :conclusion, description: "Template for material receipt document", data: "<p></p><table style=\"box-sizing: inherit; border: none; width: 1280px; display: table; border-collapse: collapse; border-spacing: 0px; empty-cells: show; max-width: 100%; color: rgb(65, 65, 65); font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255); margin-right: calc(4%);\"><tbody style=\"box-sizing: inherit;\"><tr style=\"box-sizing: inherit; border-bottom: 1px solid rgba(0, 0, 0, 0.12); user-select: none;\"><td colspan=\"2\" style=\"box-sizing: inherit; border: 1px solid rgb(221, 221, 221); padding: 15px 5px; display: table-cell; text-align: left; vertical-align: middle; border-radius: 2px; user-select: text; min-width: 5px; width: 99.9124%;\"><div style=\"box-sizing: inherit; text-align: center;\"><span style=\"box-sizing: inherit; font-size: 36px;\">MATERIAL DELIVERY</span></div></td></tr><tr style=\"box-sizing: inherit; border-bottom: 1px solid rgba(0, 0, 0, 0.12); user-select: none;\"><td style=\"box-sizing: inherit; border: 1px solid rgb(221, 221, 221); padding: 15px 5px; display: table-cell; text-align: left; vertical-align: middle; border-radius: 2px; user-select: text; min-width: 5px; width: 52.1673%;\"><p style=\"box-sizing: inherit; font-family: Muli, sans-serif; line-height: 1;\">{{customer.name}}</p><p style=\"box-sizing: inherit; font-family: Muli, sans-serif; line-height: 1;\">{{estimate.location}}</p></td><td style=\"box-sizing: inherit; border: 1px solid rgb(221, 221, 221); padding: 15px 5px; display: table-cell; text-align: left; vertical-align: top; border-radius: 2px; user-select: text; min-width: 5px; width: 47.7451%;\"><span style=\"box-sizing: inherit; font-size: 18px;\">Order No.: {{order.code}}</span><br style=\"box-sizing: inherit;\"><br style=\"box-sizing: inherit;\"><span style=\"box-sizing: inherit; color: rgb(65, 65, 65); font-family: sans-serif; font-size: 18px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; float: none; display: inline !important;\">Date: {{order.start_at}}</span></td></tr></tbody></table><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>")
        Document.create(name: "Finish Order",doc_type: :estimate,sub_type: :conclusion, description: "Template for finish order", data: "<p style=\"line-height: 115%;text-align: center;background: transparent;font-family: Calibri, serif;font-size:15px;margin-bottom: 0cm;\"></p><p style=\"line-height: 115%;text-align: center;background: transparent;font-family: Calibri, serif;font-size:15px;margin-bottom: 0cm;\"><br></p><p style=\"line-height: 115%;text-align: center;background: transparent;font-family: Calibri, serif;font-size:15px;margin-bottom: 0cm;\"><u><strong>Job Completion</strong></u></p><p style='margin-bottom: 0cm;line-height: 115%;text-align: left;background: transparent;font-family: \"Calibri\", serif;font-size:15px;'><br></p><p style='margin-bottom: 0cm;line-height: 115%;text-align: left;background: transparent;font-family: \"Calibri\", serif;font-size:15px;'>I, {{customer.name}}, attest that Face of Wood Flooring completed the job related to Order # {{order.code}} to my satisfaction.</p><p style='margin-bottom: 0cm;line-height: 115%;text-align: left;background: transparent;font-family: \"Calibri\", serif;font-size:15px;'><br></p><p style='margin-bottom: 0cm;line-height: 115%;text-align: left;background: transparent;font-family: \"Calibri\", serif;font-size:15px;'>Warranty: Face of Wood offers 1-year warranty on installation. Not included damage to flooring caused by water or moisture intrusion from walls, windows, doors, apertures, from poor drainage and changes in sub-floor moisture content not present at time of pre-installation test done with a concrete moisture meter.</p><p style='margin-bottom: 0cm;line-height: 115%;text-align: left;background: transparent;font-family: \"Calibri\", serif;font-size:15px;'><br></p><p style='margin-bottom: 0cm;line-height: 115%;text-align: left;background: transparent;font-family: \"Calibri\", serif;font-size:15px;'><br>{{order.end_at}}</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>")
        
        costs = TransactionCategory.create!(name: 'Costs', description: 'Category to associate our costs transactions', color: '#e57b95')
        labor = TransactionCategory.create!(name: 'Labor', description: 'Category to associate our labors transactions', color: '#0f34ff')
        payment = TransactionCategory.create!(name: 'Payment', description: 'Category to associate our payments transactions', color: '#15a24e')
        square = TransactionCategory.create!(name: 'Square', description: 'Category to associate our Square transactions', color: '#49a4d5')
        
        account = TransactionAccount.create!(name: 'Checking Account', description: 'Account for checking', color: '#0b56ad')

        Setting.create!([
          {namespace: 'cash_transaction_account', value: {"value"=>account.id}},
          {namespace: 'cash_transaction_category', value: {"value"=>payment.id}},

          {namespace: 'labor_cost_transaction_account', value: {"value"=>account.id}},
          {namespace: 'labor_cost_transaction_category', value: {"value"=>labor.id}},
          
          {namespace: 'check_transaction_account', value: {"value"=>account.id}},
          {namespace: 'check_transaction_category', value: {"value"=>payment.id}},

          {namespace: 'square_credit_transaction_account', value: {"value"=>account.id}},
          {namespace: 'square_credit_transaction_category', value: {"value"=>square.id}},

          {namespace: 'square_installments_transaction_account', value: {"value"=>account.id}},
          {namespace: 'square_installments_transaction_category', value: {"value"=>square.id}},

          {namespace: 'taxes_transaction_account', value: {"value"=>account.id}},
          {namespace: 'taxes_transaction_category', value: {"value"=>costs.id}},

          {namespace: 'product_purchase_transaction_account', value: {"value"=>account.id}},
          {namespace: 'product_purchase_transaction_category', value: {"value"=>costs.id}},
        ])

        square_feet = CalculationFormula.create(
          name: 'Square Feet',
          description: 'Calculate quantity based on square feet',
          formula: 'roundup(area / area_covered)'
        )

        square_feet_waste = CalculationFormula.create(
          name: 'Square Feet + 10% of waste',
          description: 'Calculate quantity based on square feet with 10% of waste',
          formula: 'roundup((area / area_covered) *1.1)'
        )

        linear_width_square_feet = CalculationFormula.create(
          name: 'Linear width',
          description: 'Calculate quantity based on linear width with 10% of waste',
          formula: 'roundup(width / area_covered)'
        )

        linear_width_square_feet_waste = CalculationFormula.create(
          name: 'Linear width + 10% of waste',
          description: 'Calculate quantity based on linear width with 10% of waste',
          formula: 'roundup((width / area_covered)*1.1)'
        )

        linear_length_square_feet = CalculationFormula.create(
          name: 'Linear length',
          description: 'Calculate quantity based on linear length with 10% of waste',
          formula: 'roundup(length / area_covered)'
        )

        linear_length_square_feet_waste = CalculationFormula.create(
          name: 'Linear length + 10% of waste',
          description: 'Calculate quantity based on linear length with 10% of waste',
          formula: 'roundup((length / area_covered)*1.1)'
        )

        linear_height_square_feet = CalculationFormula.create(
          name: 'Linear height',
          description: 'Calculate quantity based on linear height with 10% of waste',
          formula: 'roundup(height / area_covered)'
        )

        linear_height_square_feet_waste = CalculationFormula.create(
          name: 'Linear height + 10% of waste',
          description: 'Calculate quantity based on linear height with 10% of waste',
          formula: 'roundup((height / area_covered)*1.1)'
        )

        cubic_feet = CalculationFormula.create(
          name: 'Cubic feet',
          description: 'Calculate quantity based on cubic feet with 10% of waste',
          formula: 'roundup((width*length*height) / area_covered)'
        )

        cubic_feet_waste = CalculationFormula.create(
          name: 'Cubic feet + 10% of waste',
          description: 'Calculate quantity based on cubic feet with 10% of waste',
          formula: 'roundup(((width*length*height) / area_covered)*1.1)'
        )

        unitary_value = CalculationFormula.create(
          name: 'Default unitary value formula',
          namespace: 'default-formula',
          description: 'Default unitary value formula',
          formula: '1'
        )
      rescue
      end
    end
  end
  
end
