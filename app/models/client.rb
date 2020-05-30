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
                            {namespace: "company_name", value: {"value"=>"Woffice"}},
                            {namespace: "client_end_order", value: {"value"=>true}},
                            {namespace: "send_grid_key", value: {"value"=>""}},
                            {namespace: "square_key", value: {"value"=>""}},
                            {namespace: "mail_to_customer", value: {"value"=>{"send_from"=>"Customer", "template_id"=>"d-209a08276e804f778e57cefb058b52d1", "objects"=>[{"class"=>"Customer", "fields"=>[{"field"=>"nome_categoria", "sendgridkey"=>"metodo"}, {"field"=>"notes", "sendgridkey"=>"notes"}]}]}}},
                            {namespace: "order_need_sign", value: {"value"=>false}},
                            {namespace: "authenticity_token", value: {"value"=>"Me5mPkAi34kYZZ8mpbk9CvG1y0Li5fjy1Lezu8UwIg6wtIkpcjYX43n5EZdjABNQiL9dUIKf7M+1RjnthdrrUw=="}},
                            {namespace: "company_full_name", value: {"value"=>self.company_name}},
                            {namespace: "company_address", value: {"value"=>""}},
                            {namespace: "company_phone", value: {"value"=>""}},
                            {namespace: "company_email", value: {"value"=>""}},
                            {namespace: "logo", value: {"value"=>""}},
                            {namespace: "square_app_id", value: {"value"=>"sq0idp-6o0iL_Vn1ztjynF6WlRArg"}},
                            {namespace: "estimate_notes", value: {"value"=>""}},
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
        profile_admin = Profile.create( name: "Administrator", description: " System administrator profile", status: "t", permissions: {"CustomersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}, "CalculationFormulasController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "DocumentFilesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductCategoriesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "SettingsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "SuppliersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "new_contact"=>"true"}})
        profile_finance = Profile.create( name: "Finance", description: " Financial access profile", status: "t", permissions: {"CustomersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "search_by_phone"=>"true", "show"=>"true", "update"=>"true"}, "CalculationFormulasController"=>{"cache_globals_settings"=>"true", "calculate_product_qty_lw"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "DocumentFilesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductCategoriesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "SuppliersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}})
        profile_worker = Profile.create(name: "Worker", description: " Worker profile", status: "t", permissions: {"ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "load_notes"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}})
        profile_purchase = Profile.create( name: "Purchase", description: "Purchase profiles", status: "t", permissions: {"CustomersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "home"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "search_by_phone"=>"true", "search_customers"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "DocumentFilesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "ProductCategoriesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "ProductsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "SuppliersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}})



        customer = Menu.create(active: true, icon: "face", name: "Customer", url: "/customers", ancestry: nil, position: 4)
        workers = Menu.create(active: true, icon: "business_center", name: "Workers", url: "/workers", ancestry: nil, position: 5)
        estimates = Menu.create(active: true, icon: "assignment_turned_in", name: "Estimates", url: "/estimates", ancestry: nil, position: 2)
        schedules = Menu.create(active: true, icon: "event_note", name: "Schedules", url: "/schedules", ancestry: nil, position: 6)
        orders = Menu.create(active: true, icon: "assignment_ind", name: "Orders", url: "/orders", ancestry: nil, position: 3)
        leads = Menu.create(active: true, icon: "assignment", name: "Leads", url: "/leads", ancestry: nil, position: 1)
        configuration = Menu.create(active: true, icon: "settings", name: "Settings", url: "#", ancestry: nil, position: 10)
        settings = Menu.create(active: true, icon: "build", name: "System Configuration", url: "/settings", parent: configuration, position: 1)
        calculation_formula = Menu.create(active: true, icon: "local_atm", name: "Calculation Formula", url: "/calculation_formulas", parent: configuration, position:2)
        documents = Menu.create(active: true, icon: "description", name: "Documents", url: "/documents", parent: configuration, position: 3)
        security = Menu.create(active: true, icon: "security", name: "Security", url: "#", parent: configuration, position: 4)
        portifolio = Menu.create(active: true, icon: "chrome_reader_mode", name: "Portifolio", url: "#", ancestry: nil, position: 8)
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
      rescue
      end
    end
  end
end
