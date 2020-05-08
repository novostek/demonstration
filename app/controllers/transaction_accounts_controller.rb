class TransactionAccountsController < ApplicationController
  #load_and_authorize_resource
  before_action :set_transaction_account, only: [:show, :edit, :update, :destroy]

  # GET /transaction_accounts
  def index
    @q = TransactionAccount.all.ransack(params[:q])
    @transaction_accounts = @q.result.page(params[:page])
  end

  # GET /transaction_accounts/1
  def show
  end

  # GET /transaction_accounts/new
  def new
    @transaction_account = TransactionAccount.new
  end

  # GET /transaction_accounts/1/edit
  def edit
  end

  # POST /transaction_accounts
  def create
    @transaction_account = TransactionAccount.new(transaction_account_params)

    if @transaction_account.save
      redirect_to @transaction_account, notice: t('notice.transaction_account.created')
    else
      render :new
    end
  end

  # PATCH/PUT /transaction_accounts/1
  def update
    if @transaction_account.update(transaction_account_params)
      redirect_to @transaction_account, notice: t('notice.transaction_account.updated')
    else
      render :edit
    end
  end

  # DELETE /transaction_accounts/1
  def destroy
    @transaction_account.destroy
    redirect_to transaction_accounts_url, notice: t('notice.transaction_account.deleted')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction_account
      @transaction_account = TransactionAccount.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_account_params
      params.require(:transaction_account).permit(:name, :description, :color, :namespace)
    end
end
