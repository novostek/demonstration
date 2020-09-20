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
                            {namespace: "send_square_mail_text", value: {"value"=>"<p>#{t 'texts.client.pay_text' } <strong>#{t 'texts.client.example'}</strong></p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">#{t 'texts.layout.powered_by'} <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>"}},
                            {namespace: "send_invoice_mail_text", value: {"value"=>"<p>#{t 'texts.client.text_example' }</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">#{t 'texts.layout.powered_by' } <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>"}},
                            {namespace: "send_document_mail_text", value: {"value"=>"<p>#{t 'texts.client.text_example' }</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">#{t 'texts.layout.powered_by' } <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>"}},
                            {namespace: "sign_order_mail_text", value: {"value"=>"<p>#{t 'texts.client.sign_submitted_document'}</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">#{t 'texts.layout.powered_by' } <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>"}}
                        ])
        profile_admin = Profile.create( name: t('texts.client.administrator'), description: t('texts.client.system_administrator_profile'), status: "t", permissions: {"CalculationFormulasController":{"cache_globals_settings":"true","calculate_product_qty_lw":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","taxes":"true","toastr":"true","update":"true"},"ContactsController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"CustomersController":{"add_card":"true","cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","mail_card":"true","new":"true","new_contact":"true","new_document":"true","new_note":"true","search_by_email":"true","search_by_phone":"true","search_customers":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"DocumentFilesController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"DocumentsController":{"add_custom":"true","cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","preview":"true","save_data":"true","send_customs":"true","send_mail":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"EstimatesController":{"cache_globals_settings":"true","cancel":"true","clone":"true","create":"true","create_order":"true","create_products_estimates":"true","create_schedule":"true","create_step_one":"true","delete_schedule":"true","destroy":"true","edit":"true","estimate_signature":"true","index":"true","new":"true","new_document":"true","new_note":"true","products":"true","reactivate":"true","schedule":"true","see_price":"true","send_grid_mail":"true","send_mail":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","step_one":"true","tax_calculation":"true","taxpayer":"true","toastr":"true","update":"true","view_estimate":"true"},"FinancesController":{"cache_globals_settings":"true","dashboard":"true","set_default_breadcrumbs":"true","set_smtp":"true","toastr":"true"},"LaborCostsController":{"cache_globals_settings":"true","change_status":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","new_document":"true","new_note":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"LeadsController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"MeasurementAreasController":{"cache_globals_settings":"true","create":"true","create_measurements":"true","destroy":"true","edit":"true","index":"true","measurements":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"MeasurementProposalsController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"MeasurementsController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"MenusController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"NotesController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"OrdersController":{"cache_globals_settings":"true","cancel":"true","change_order":"true","change_order_old":"true","change_payment_status_to_pendent":"true","change_transaction_value":"true","costs":"true","create":"true","create_schedule":"true","delete_schedule":"true","deliver_products":"true","deliver_products_sign":"true","destroy":"true","doc_signature":"true","doc_signature_mail":"true","edit":"true","finish":"true","finish_order":"true","finish_order_signature":"true","index":"true","invoice":"true","invoice_add_payment":"true","new":"true","new_contact":"true","new_cost":"true","new_document":"true","new_labor_cost":"true","new_note":"true","order_photos":"true","payments":"true","pendent_payments":"true","product_purchase":"true","reactivate":"true","schedule":"true","see_price":"true","send_invoice_mail":"true","send_sign_mail":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true","view_invoice_customer":"true"},"ProductCategoriesController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"ProductEstimatesController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"ProductPurchasesController":{"cache_globals_settings":"true","change_status":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","new_document":"true","new_note":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"ProductsController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","new_delivery":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"ProfilesController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"PurchasesController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"SchedulesController":{"cache_globals_settings":"true","create":"true","delete_schedule":"true","index":"true","load_notes":"true","new_document":"true","new_note":"true","redirect_schedule":"true","set_default_breadcrumbs":"true","set_smtp":"true","toastr":"true","update_hour_cost":"true"},"SettingsController":{"atualiza_settings":"true","atualiza_transactions":"true","cache_globals_settings":"true","cached_logo":"true","company_banner":"true","company_logo":"true","create":"true","destroy":"true","edit":"true","email":"true","estimate":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","transactions":"true","update":"true"},"SignaturesController":{"base64_to_file":"true","cache_globals_settings":"true","create_old":"true","create_sign":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"SquareApiController":{"add_card":"true","cache_globals_settings":"true","callback":"true","checkout":"true","nonce":"true","oauth":"true","process_payment":"true","set_default_breadcrumbs":"true","set_smtp":"true","toastr":"true"},"SuppliersController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","new_contact":"true","new_document":"true","new_note":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"TransactionAccountsController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"TransactionCategoriesController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"TransactionsController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","new":"true","paid":"true","send_square":"true","send_square_again":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"UsersController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","home":"true","index":"true","new":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"},"WorkersController":{"cache_globals_settings":"true","create":"true","destroy":"true","edit":"true","index":"true","load_notes":"true","new":"true","new_contact":"true","new_document":"true","new_note":"true","set_default_breadcrumbs":"true","set_smtp":"true","show":"true","toastr":"true","update":"true"}})
        profile_finance = Profile.create( name: t('texts.client.finance'), description: t('texts.client.financial_access_profile'), status: "t", permissions: {"CustomersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "search_by_phone"=>"true", "show"=>"true", "update"=>"true"}, "CalculationFormulasController"=>{"cache_globals_settings"=>"true", "calculate_product_qty_lw"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "DocumentFilesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductCategoriesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "ProductsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "update"=>"true"}, "SuppliersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "update"=>"true"}})
        profile_worker = Profile.create(name: t('texts.client.worker'), description: t('texts.client.worker_profile'), status: "t", permissions: {"ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "load_notes"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}})
        profile_purchase = Profile.create( name: t('texts.client.purchase'), description: t('texts.client.purchase_profiles'), status: "t", permissions: {"CustomersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "home"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "search_by_phone"=>"true", "search_customers"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "ContactsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "DocumentFilesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "NotesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "ProductCategoriesController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "ProductsController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "SuppliersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}, "WorkersController"=>{"cache_globals_settings"=>"true", "create"=>"true", "destroy"=>"true", "edit"=>"true", "index"=>"true", "new"=>"true", "new_contact"=>"true", "new_document"=>"true", "new_note"=>"true", "show"=>"true", "toastr"=>"true", "update"=>"true"}})



        customer = Menu.create(active: true, icon: "face", name: t('activerecord.models.customers'), url: "/customers", ancestry: nil, position: 4)
        workers = Menu.create(active: true, icon: "business_center", name: t('activerecord.models.workers'), url: "/workers", ancestry: nil, position: 5)
        estimates = Menu.create(active: true, icon: "assignment_turned_in", name: t('activerecord.models.estimates'), url: "/estimates", ancestry: nil, position: 2)
        schedules = Menu.create(active: true, icon: "event_note", name: t('activerecord.models.schedules'), url: "/schedules", ancestry: nil, position: 6)
        orders = Menu.create(active: true, icon: "assignment_ind", name: t('activerecord.models.orders'), url: "/orders", ancestry: nil, position: 3)
        leads = Menu.create(active: true, icon: "assignment", name: t('activerecord.models.leads'), url: "/leads/new", ancestry: nil, position: 1)
        configuration = Menu.create(active: true, icon: "settings", name: t('activerecord.models.settings'), url: "#", ancestry: nil, position: 10)
        settings = Menu.create(active: true, icon: "build", name: t('texts.client.system_configuration'), url: "/settings", parent: configuration, position: 1)
        calculation_formula = Menu.create(active: true, icon: "local_atm", name: t('activerecord.models.calculation_formula'), url: "/calculation_formulas", parent: configuration, position:2)
        documents = Menu.create(active: true, icon: "description", name: t('documents'), url: "/documents", parent: configuration, position: 3)
        security = Menu.create(active: true, icon: "security", name: t('texts.client.security'), url: "#", parent: configuration, position: 4)
        portifolio = Menu.create(active: true, icon: "chrome_reader_mode", name: t('texts.client.portfolio'), url: "#", ancestry: nil, position: 8)
        products = Menu.create(active: true, icon: "local_grocery_store", name: t('activerecord.models.products'), url: "/products", parent: portifolio, position: 1)
        suppliers = Menu.create(active: true, icon: "local_shipping", name: t('activerecord.models.suppliers'), url: "/suppliers", parent: portifolio, position: 2)
        produc_category = Menu.create(active: true, icon: "widgets", name: t('activerecord.models.product_categories'), url: "/product_categories", parent: portifolio, position: 3)
        finances = Menu.create(active: true, icon: "monetization_on", name: t('texts.client.finances'), url: "#", ancestry: nil, position: 6)
        transactions = Menu.create(active: true, icon: "monetization_on", name: t('activerecord.models.transactions'), url: "/transactions", parent: finances, position: 1)
        transaction_accounts = Menu.create(active: true, icon: "account_balance_wallet", name: t('accounts'), url: "/transaction_accounts", parent: finances, position: 2)
        transaction_categories = Menu.create( active: true, icon: "donut_small", name: t('texts.client.categories'), url: "/transaction_categories", parent: finances, position: 3)


        users = Menu.create(active: true, icon: "person_add", name: t('activerecord.models.users'), url: "/users", parent: security, position: 1)
        profile = Menu.create(active: true, icon: "person_pin", name: t('activerecord.models.profiles'), url: "/profiles", parent: security, position: 2)
        menus = Menu.create(active: true, icon: "view_list", name: t('texts.client.menu_access'), url: "/menus", parent: security, position: 3)
        

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
        Document.create(name: t('texts.client.material_delivery'),doc_type: :estimate,sub_type: :conclusion, description: t('texts.client.template_for_material_receipt_document'), data: "<p></p><table style=\"box-sizing: inherit; border: none; width: 1280px; display: table; border-collapse: collapse; border-spacing: 0px; empty-cells: show; max-width: 100%; color: rgb(65, 65, 65); font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255); margin-right: calc(4%);\"><tbody style=\"box-sizing: inherit;\"><tr style=\"box-sizing: inherit; border-bottom: 1px solid rgba(0, 0, 0, 0.12); user-select: none;\"><td colspan=\"2\" style=\"box-sizing: inherit; border: 1px solid rgb(221, 221, 221); padding: 15px 5px; display: table-cell; text-align: left; vertical-align: middle; border-radius: 2px; user-select: text; min-width: 5px; width: 99.9124%;\"><div style=\"box-sizing: inherit; text-align: center;\"><span style=\"box-sizing: inherit; font-size: 36px;\">#{t('texts.client.material_delivery').upcase}</span></div></td></tr><tr style=\"box-sizing: inherit; border-bottom: 1px solid rgba(0, 0, 0, 0.12); user-select: none;\"><td style=\"box-sizing: inherit; border: 1px solid rgb(221, 221, 221); padding: 15px 5px; display: table-cell; text-align: left; vertical-align: middle; border-radius: 2px; user-select: text; min-width: 5px; width: 52.1673%;\"><p style=\"box-sizing: inherit; font-family: Muli, sans-serif; line-height: 1;\">{{customer.name}}</p><p style=\"box-sizing: inherit; font-family: Muli, sans-serif; line-height: 1;\">{{estimate.location}}</p></td><td style=\"box-sizing: inherit; border: 1px solid rgb(221, 221, 221); padding: 15px 5px; display: table-cell; text-align: left; vertical-align: top; border-radius: 2px; user-select: text; min-width: 5px; width: 47.7451%;\"><span style=\"box-sizing: inherit; font-size: 18px;\">#{t'texts.client.order_number'}: {{order.code}}</span><br style=\"box-sizing: inherit;\"><br style=\"box-sizing: inherit;\"><span style=\"box-sizing: inherit; color: rgb(65, 65, 65); font-family: sans-serif; font-size: 18px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; float: none; display: inline !important;\">#{t'texts.date'}: {{order.start_at}}</span></td></tr></tbody></table><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">#{t'texts.layout.powered_by'} <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>")
        Document.create(name: t('texts.client.finish_order'),doc_type: :estimate,sub_type: :conclusion, description: t('texts.client.template_for_finish_order'), data: "<p style=\"line-height: 115%;text-align: center;background: transparent;font-family: Calibri, serif;font-size:15px;margin-bottom: 0cm;\"></p><p style=\"line-height: 115%;text-align: center;background: transparent;font-family: Calibri, serif;font-size:15px;margin-bottom: 0cm;\"><br></p><p style=\"line-height: 115%;text-align: center;background: transparent;font-family: Calibri, serif;font-size:15px;margin-bottom: 0cm;\"><u><strong>#{t 'texts.client.job_completion'}</strong></u></p><p style='margin-bottom: 0cm;line-height: 115%;text-align: left;background: transparent;font-family: \"Calibri\", serif;font-size:15px;'><br></p><p style='margin-bottom: 0cm;line-height: 115%;text-align: left;background: transparent;font-family: \"Calibri\", serif;font-size:15px;'>#{t 'texts.client.i'} {{customer.name}}, #{t 'texts.client.attest_completed_the_job'} # {{order.code}} #{t 'texts.client.to_my_satisfaction'}</p><p style='margin-bottom: 0cm;line-height: 115%;text-align: left;background: transparent;font-family: \"Calibri\", serif;font-size:15px;'><br></p><p style='margin-bottom: 0cm;line-height: 115%;text-align: left;background: transparent;font-family: \"Calibri\", serif;font-size:15px;'>#{t 'texts.client.warranty_on_installation'}</p><p style='margin-bottom: 0cm;line-height: 115%;text-align: left;background: transparent;font-family: \"Calibri\", serif;font-size:15px;'><br></p><p style='margin-bottom: 0cm;line-height: 115%;text-align: left;background: transparent;font-family: \"Calibri\", serif;font-size:15px;'><br>{{order.end_at}}</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">#{t 'texts.layout.powered_by'} <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>")

        costs = TransactionCategory.create!(name: t('texts.client.costs'), description: t('texts.client.category_associate_our_costs_transactions'), color: '#e57b95')
        labor = TransactionCategory.create!(name: t('texts.client.labor'), description: t('texts.client.category_associate_our_costs_transactions'), color: '#0f34ff')
        payment = TransactionCategory.create!(name: t('texts.payment'), description: t('texts.client.category_associate_our_costs_transactions'), color: '#15a24e')
        square = TransactionCategory.create!(name: t('texts.client.square'), description: t('texts.client.category_associate_our_costs_transactions'), color: '#49a4d5')

        account = TransactionAccount.create!(name: t('texts.client.checking_account'), description: t('texts.client.account_for_checking'), color: '#0b56ad')

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
          {namespace: 'verificated', value: {"value"=>false}},
          {namespace: 'welcome', value: {"value"=>false}},
        ])

        square_feet = CalculationFormula.create(
          name: t('texts.client.square_feet'),
          description: t('texts.client.calculate_quantity_based_square_feet'),
          formula: 'roundup(area / area_covered)'
        )

        square_feet_waste = CalculationFormula.create(
          name: t('texts.client.square_feet_10_of_waste'),
          description: t('texts.client.calculate_based_square_feet_10_of_waste'),
          formula: 'roundup((area / area_covered) *1.1)'
        )

        linear_width_square_feet = CalculationFormula.create(
          name: t('texts.client.linear_width'),
          description: t('texts.client.calculate_based_linear_width_10_of_waste'),
          formula: 'roundup(width / area_covered)'
        )

        linear_width_square_feet_waste = CalculationFormula.create(
          name: t('texts.client.calculate_based_linear_width_10_of_waste'),
          description: t('texts.client.calculate_based_linear_width_10_of_waste'),
          formula: 'roundup((width / area_covered)*1.1)'
        )

        linear_length_square_feet = CalculationFormula.create(
          name: t('texts.client.linear_length'),
          description: t('texts.client.calculate_based_linear_length_10_of_waste'),
          formula: 'roundup(length / area_covered)'
        )

        linear_length_square_feet_waste = CalculationFormula.create(
          name: t('texts.client.linear_length_10_of_waste'),
          description: t('texts.client.calculate_based_linear_length_10_of_waste'),
          formula: 'roundup((length / area_covered)*1.1)'
        )

        linear_height_square_feet = CalculationFormula.create(
          name: t('texts.client.linear_height'),
          description: t('texts.client.calculate_based_linear_height_10_of_waste'),
          formula: 'roundup(height / area_covered)'
        )

        linear_height_square_feet_waste = CalculationFormula.create(
          name: t('texts.client.linear_height_10_of_waste'),
          description: t('texts.client.calculate_based_linear_height_10_of_waste'),
          formula: 'roundup((height / area_covered)*1.1)'
        )

        cubic_feet = CalculationFormula.create(
          name: t('texts.client.cubic_feet'),
          description: t('texts.client.calculate_based_cubic_feet_10_of_waste'),
          formula: 'roundup((width*length*height) / area_covered)'
        )

        cubic_feet_waste = CalculationFormula.create(
          name: t('texts.client.cubic_feet_10_of_waste'),
          description: t('texts.client.calculate_based_cubic_feet_10_of_waste'),
          formula: 'roundup(((width*length*height) / area_covered)*1.1)'
        )

        unitary_value = CalculationFormula.create(
          name: t('texts.client.default_unitary_value_formula'),
          namespace: 'default-formula',
          description: t('texts.client.default_unitary_value_formula'),
          formula: '1'
        )
      rescue
      end
    end
  end

  # Método que cria os registros usados ​​no Onboarding
  def self.init_onboard
    # New customer
    customer = Customer.create name: I18n.t('texts.client.onboard.customer'), category: :person, contacts_attributes: [{category: :phone, title: I18n.t('texts.client.onboard.main_phone'), data: {"phone":I18n.t('texts.client.onboard.phone_value')}, main: true}, {category: :email, title: I18n.t('texts.client.onboard.main_email'), data: {"email":I18n.t('texts.client.onboard.email_value')}, main: true}]

    # New lead
    lead = Lead.create via: 'System', status: :new, customer: customer, description: I18n.t('texts.client.onboard.lead'), phone: I18n.t('texts.client.onboard.phone_value'), email: I18n.t('texts.client.onboard.email_value'), date: DateTime.now

    # New Worker
    sales_person = Worker.create name: I18n.t('texts.client.onboard.worker'), categories: :employee

    # New ProductCategory
    product_category = ProductCategory.create name: I18n.t('texts.client.onboard.product_category'), namespace: I18n.t('texts.client.onboard.product_category_namespace')

    # New Supplier
    supplier = Supplier.create name: I18n.t('texts.client.onboard.supplier'), active: true

    # Find ou Create CalculationFormula default
    cal_formula = CalculationFormula.first

    # New Products
    p_a = Product.create name: I18n.t('texts.client.onboard.prod_1'), details: I18n.t('texts.client.onboard.prod_1_desc'), customer_price: 10, cost_price: 5, area_covered: 5, tax: false, active: true, calculation_formula_id: cal_formula.id, product_category_id: product_category.id, supplier_id: supplier.id
    p_b = Product.create name: I18n.t('texts.client.onboard.prod_2'), details: I18n.t('texts.client.onboard.prod_2_desc'), customer_price: 10, cost_price: 5, area_covered: 5, tax: false, active: true, calculation_formula_id: cal_formula.id, product_category_id: product_category.id, supplier_id: supplier.id

    p_c = Product.create name: I18n.t('texts.client.onboard.prod_3'), details: I18n.t('texts.client.onboard.prod_3_desc'), customer_price: 10, cost_price: 5, area_covered: 5, tax: false, active: true, calculation_formula_id: cal_formula.id, product_category_id: product_category.id, supplier_id: supplier.id#, product_suggestions_attributes: [{suggestion_id: p_a.id}, {suggestion_id: p_b.id}]
    p_c.product_suggestions.build(suggestion: p_a).save
    p_c.product_suggestions.build(suggestion: p_b).save

    # New Estimate
    estimate = Estimate.find_or_initialize_by lead_id: lead.id
    estimate.assign_attributes title: I18n.t('texts.client.onboard.estimate'), sales_person_id: sales_person.id, status: :new, description: I18n.t('texts.client.onboard.estimate_desc'), location: I18n.t('texts.client.onboard.estimate_location'), latitude: I18n.t('texts.client.onboard.estimate_lat'), longitude: I18n.t('texts.client.onboard.estimate_long'), category: :estimate, current: false, total: 0, taxpayer: :customer, payment_approval: true,
                               measurement_areas_attributes: [{name: I18n.t('texts.client.onboard.area'), measurements_attributes: [{width: 10,length: 10, height:10, measures:"{\"value\"=>[{\"width\"=>0.0, \"length\"=>0.0, \"square_feet\"=>0.0}]}"}], measurement_proposals_attributes: [{product_estimates_attributes: [{product_id: p_c.id, unitary_value: p_c.customer_price, quantity: 1, value: p_c.customer_price, tax: false}]} ]}]
    estimate.save

    TransactionCategory.find_or_create_by name: 'Costs', description: 'Category to associate our costs transactions'

    TransactionAccount.find_or_create_by name: 'Checking Account', description: 'Account for checking'

    # New Order
    estimate.create_order
  end

end
