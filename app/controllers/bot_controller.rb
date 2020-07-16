class BotController < ApplicationController
  # before_filter :before_login, :only => :create
  # after_action :initialization, :only => :create, if: 
  # before_action :require_validate, :only => :initialization

  layout 'initialization'

  def initialization
    redirect_to finance_dashboard_path if Setting.get_value('verified')
  end

  def create_initialization
    company_address = Setting.find_or_initialize_by(namespace: 'company_address')
    company_address.value = {"value": params[:company_address]}
    company_address.save

    company_email = Setting.find_or_initialize_by(namespace: 'company_email')
    company_email.value = {"value": params[:company_email]}
    company_email.save
    
    company_fullname = Setting.find_or_initialize_by(namespace: 'company_full_name')
    company_fullname.value = {"value": params[:company_fullname]}
    company_fullname.save
    
    company_name = Setting.find_or_initialize_by(namespace: 'company_name')
    company_name.value = {"value": params[:company_name]}
    company_name.save
    
    company_phone = Setting.find_or_initialize_by(namespace: 'company_phone')
    company_phone.value = {"value": params[:company_phone]}
    company_phone.save

    if params['up-logo'] == 'yes'
      doc = DocumentFile.find_or_initialize_by(origin: "Logo", origin_id: '1e1e3f7b-92f7-4da4-8894-1bfbfb24d39b')
      doc.title = "Logo"
      doc.file = params[:company_logo]
      doc.save
      s = Setting.find_or_initialize_by(namespace: "logo")
      s.value = {"value": doc.file.url }
      s.save
    end

    # {"value":{"width":false,"length":false,"height":false,"square_feet":true}}
    measures = params[:measures]
    value = {}
    measures.each do |m|
      if m == 'w'
        value[:width] = true
      elsif m == 'l'
        value[:length] = true
      elsif m == 'h'
        value[:height] = true
      elsif m == 'sqft'
        value[:square_feet] = true
      end
    end

    measures = Setting.find_or_initialize_by(namespace: 'hidden_measurement_fields')
    measures.value = {"value": value}
    measures.save
    
    if params['custom-account'][0] == 'yes'
      transaction_account = TransactionAccount.find_or_initialize_by(name: 'Checking Account')
      transaction_account.name = params[:company_main_account]
      transaction_account.description = params[:company_main_account]
      transaction_account.color = '#0b56ad'
      transaction_account.save
    end
    
    tax_formula = CalculationFormula.find_or_initialize_by(namespace: 'tax-formula')
    tax_formula.name = "Tax formula"
    tax_formula.tax = true
    tax_formula.formula = "total * #{params[:company_tax].to_f / 100}"
    tax_formula.save

    verified = Setting.find_or_initialize_by(namespace: 'verified')
    verified.value = {"value": true}
    verified.save
  end

  private

  def require_validate
    unless !(Setting.get_value('verified') or !Setting.get_value('default_url').empty?)
      redirect_to finance_dashboard_path 
    end
  end
end