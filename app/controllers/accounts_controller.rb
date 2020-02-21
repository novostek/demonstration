class AccountsController  < ApplicationController


  def index
    @accounts = Plutus::Account.all
  end

  def new
    @account = Plutus::Account.new
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
      redirect_to entries_accounts_path, notice: "Entry was successful created."
    else
      render :new_entry
    end
  end

  def create
    @account = Plutus::Account.new(account_params)
    if @account.save
      redirect_to accounts_path, notice: 'Account was sucessful created.'
    else
      render :new
    end
  end

  # PATCH/PUT /profiles/1
  def update

    if @account.update(account_params)
      redirect_to @account, notice: 'Product foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /profiles/1
  def destroy
    @profile.destroy
    redirect_to profiles_url, notice: 'Profile foi apagado com sucesso.'
  end

  private


  # Only allow a trusted parameter "white list" through.
  def account_params
    params.require(:account).permit(:name, :type)
  end

end