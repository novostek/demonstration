class BotController < ApplicationController
  # before_filter :before_login, :only => :create
  after_filter :initialization, :only => :create, if: 

  def initialization
    render :layout => 'initialization'
  end

  def create_initialization
    company_address = Setting.find_or_initialize_by(namespace: 'company_address')
    company_address.value = {"value": params[:company_address]}
    company_address.save

    company_email = Setting.find_or_initialize_by(namespace: 'company_email')
    company_email.value = {"value": params[:company_email]}
    company_email.save
    
    company_fullname = Setting.find_or_initialize_by(namespace: 'company_fullname')
    company_fullname.value = {"value": params[:company_fullname]}
    company_fullname.save
    
    company_name = Setting.find_or_initialize_by(namespace: 'company_name')
    company_name.value = {"value": params[:company_name]}
    company_name.save
    
    company_phone = Setting.find_or_initialize_by(namespace: 'company_phone')
    company_phone.value = {"value": params[:company_phone]}
    company_phone.save

    doc = DocumentFile.find_or_initialize_by(origin: "Logo", origin_id: SecureRandom.uuid)
    doc.title = "Logo"
    doc.file = params[:company_logo]
    doc.save
    s = Setting.find_or_initialize_by(namespace: "logo")
    s.value = {"value": doc.file.url }
    s.save

    if params[:custom_account][0] == 'yes'
      transaction_account = TransactionAccount.find_or_initialize_by(name: 'Checking Account')
      transaction_account.name = params[:company_main_account]
      transaction_account.description = params[:company_main_account]
      transaction_account.color = '#0b56ad'
      transaction_account.save
    end
  end
end