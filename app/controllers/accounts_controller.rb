class AccountsController  < ApplicationController
  load_and_authorize_resource
  before_action :set_combos, only: [:new, :edit, :update, :create]
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  def index
    @accounts = Plutus::Account.all
  end

  def new
    @account = Plutus::Account.new
  end

  def show
    
  end

  def edit
    
  end

  def balance
    first_entry = Plutus::Entry.order('date ASC').first
    @from_date = first_entry ? first_entry.date: Date.today
    @to_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @assets = Plutus::Asset.all
    @liabilities = Plutus::Liability.all
    @equity = Plutus::Equity.all
  end

  def new_entry
    @entry = Plutus::Entry.new
    @entry.debit_amounts.build
  end

  def entries
    @entries = Plutus::Entry.all
  end

  def create_entry
    description = params[:entry][:description]
    date = params[:entry][:date]
    debits = []

    if params[:entry][:debit_amounts_attributes].present?
      params[:entry][:debit_amounts_attributes].keys.each do |key|
        data = {account_name: params[:entry][:debit_amounts_attributes]["#{key}"][:account], amount: params[:entry][:debit_amounts_attributes]["#{key}"][:amount] }
        debits << data
      end
    end

    credits = []
    if params[:entry][:credit_amounts_attributes].present?
      params[:entry][:credit_amounts_attributes].keys.each do |key|
        data = {account_name: params[:entry][:credit_amounts_attributes]["#{key}"][:account], amount: params[:entry][:credit_amounts_attributes]["#{key}"][:amount] }
        credits << data
      end
    end

    entry = Plutus::Entry.build(description: description, date: date, debits: debits, credits: credits)
    @entry = entry
    if entry.save
      redirect_to entries_accounts_path, notice: t('notice.entry.created')
    else
      render :new_entry
    end
  end

  def create
    @account = Plutus::Account.new(account_params)
    if @account.save
      redirect_to accounts_path, notice: t('notice.entry.created')
    else
      render :new
    end
  end

  # PATCH/PUT /profiles/1
  def update

    if @account.update(account_params)
      redirect_to @account, notice: t('notice.account.updated')
    else
      render :edit
    end
  end

  # DELETE /profiles/1
  def destroy
    @account.destroy
    redirect_to accounts_path, notice: t('notice.account.deleted')
  end

  private

  def set_account
    @account = Plutus::Account.find(params[:id])
  end

  def set_combos
    @categories = TransactionCategory.to_select
  end


  # Only allow a trusted parameter "white list" through.
  def account_params
    params.require(:account).permit(:name, :type, :transaction_category_id)
  end

end