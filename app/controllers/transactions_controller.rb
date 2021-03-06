class TransactionsController < ApplicationController
  load_and_authorize_resource except: [:send_square, :show, :edit, :update]
  before_action :set_transaction, only: [:show, :edit, :update, :destroy,:send_square,:send_square_again, :paid, :refund]
  before_action :set_combos, only: [:new,:edit,:create,:update, :index]

  # GET /transactions
  def index
    @filtered = params[:q].present?
    if @filtered and params[:q][:status_eq] == "cancelled"
      @q = Transaction.unscoped.all.order(created_at: :desc).ransack(params[:q])
    else
      @q = Transaction.all.order(created_at: :desc).ransack(params[:q])
    end
    @transactions = @q.result.page(params[:page]).per(10)


    @overdue = Transaction.get_amount_of_overdue
    @open = Transaction.get_amount_of_open
    @paid = Transaction.get_amount_of_receivables

    @year_incomes = Transaction.get_thirty_days_finances('income')
    @year_costs = Transaction.get_thirty_days_finances('cost')

    @balance = []

    @year_incomes.each do |income|
      cost = @year_costs.detect { |c| c[:month] == income[:month] }
      if cost.present? and income[:month] == cost[:month]
        @balance.push({
          :month => income[:month],
          :value => income[:value] - cost[:value]
        })
      end
    end

    @total_balance = {value: @balance.sum {|el| el[:value]} }
    begin
      value= @total_balance[:value]
    rescue
      @total_balance= {value: 0}
    end

    if params[:button].present? and params[:button] == 'btn-export' and params[:type].present?
      send_data @q.result.export_to(params[:type]), filename: "transactions.#{params[:type]}"
    end
  end

  #Método que reenvia o email com o checkout para o cliente
  def send_square_again
    checkout_status, checkout_data = @transaction.send_square_from_invoice
    if checkout_status
      DocumentMailer.with(transaction: @transaction, link: checkout_data[:checkout][:checkout_page_url] , emails: params[:emails], order: @transaction.order).send_square.deliver_later
      redirect_to invoice_order_path(@transaction.order), notice: t('notice.transaction.mail_sent')
    else
      redirect_to invoice_order_path(@transaction.order), notice: t('notice.transaction.error')
    end

  end


  #Método para o cliente ao visuzliar o invoice, realizar o pagamento pendente via square
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
      redirect_to @transaction, notice: t('notice.transaction.created')
    else
      render :new
    end
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, notice: t('notice.transaction.updated')
    else
      render :edit
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: t('notice.transaction.deleted')
  end

  def paid
    if @transaction.mark_as_paid
      render js: "location.reload();"
    else
      render js: "swal('Error', #{t('notice.transaction.swal_error')}, 'error')"
    end

  end

  # Faz reembolso de uma transacao (SquareCredit ou WofficePay)
  def refund
    result = @transaction.refund

    if result
      redirect_to transactions_path, notice: t('notice.transaction.refunded')
    else
      redirect_to transactions_path, notice: t('notice.transaction.unable_to_refund')
    end
  end

  private

  def set_combos
    @categories = TransactionCategory.to_select
    @accounts = TransactionAccount.to_select
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.unscoped.find(params[:id])
      if ["show", "edit", "update"].include? params[:action]
        if params[:action] == 'show'
          if cannot? :show, Transaction
            render "pages/denied", layout: false
          end
        else
          if cannot? :update, Transaction
            render "pages/denied", layout: false
          end
        end
      end
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params
      params.require(:transaction).permit(:title, :category, :transaction_category_id, :transaction_account_id, :order_id, :origin, :due, :effective, :value, :status)
    end
end
