class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy,:send_square]
  before_action :set_combos, only: [:new,:edit,:create,:update]

  # GET /transactions
  def index
    @q = Transaction.all.ransack(params[:q])
    @transactions = @q.result.page(params[:page])
  end


  def send_square
    checkout_status, checkout_data = @transaction.send_square_from_invoice
    if checkout_status
      redirect_to checkout_data[:checkout][:checkout_page_url]
    else
      redirect_to invoice_order_path(@transaction.order), notice: checkout_status
    end
  end

  # GET /transactions/1
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      redirect_to @transaction, notice: 'Transaction foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, notice: 'Transaction foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: 'Transaction foi apagado com sucesso.'
  end

  private

  def set_combos
    @categories = TransactionCategory.to_select
    @accounts = TransactionAccount.to_select
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params
      params.require(:transaction).permit(:category, :transaction_category_id, :transaction_account_id, :order_id, :origin, :due, :effective, :value, :bpm_instance)
    end
end
