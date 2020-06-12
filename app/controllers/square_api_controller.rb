class SquareApiController < ApplicationController

  def oauth
    ##{Rails.configuration.woffice['url']}
    #https://connect.squareupsandbox.com/oauth2/authorize?client_id=sandbox-sq0idb-g75z4FJpMVE0s9qUn7GTmQ&scope=ORDERS_WRITE PAYMENTS_WRITE MERCHANT_PROFILE_READ PAYMENTS_READ
    SquareApi.save_access_token(params[:code])
    if params[:code].present?
      s = Setting.find_or_initialize_by(namespace: "square_oauth_code")
      s.value = {"value": params[:code] }
      s.save
    end
      #render json: {msg: "OK"}
    redirect_to settings_path, notice: "Square Linked"
  end

  def callback
    result, square_transaction = SquareApi.get_transaction(params[:transactionId])
    if result
      #binding.pry
      @transaction = Transaction.find_or_initialize_by(id: params[:transaction])
      @transaction.category = "Square"
      #transaction.due =  square_transaction.transaction[:created_at].to_date
      @transaction.effective = square_transaction.transaction[:tenders].first[:created_at]
      @transaction.value = square_transaction.transaction[:tenders].first[:amount_money][:amount] / 100.00
      @transaction.square_data = square_transaction.transaction
      @transaction.status = :paid
      @transaction.payment_method = :square_credit
      @transaction.save

    end
    render layout: "callback"
  end

  def checkout
    checkout_status, checkout_data = SquareApi.create_checkout
    if checkout_status
      redirect_to checkout_data[:checkout][:checkout_page_url]
    else
      redirect_to process_payment_customers_path
    end

  end

  #Método utilizado para capiturar o cartão do cliente
  def nonce
    @estimate = Estimate.find(params[:estimate])
    @customer = @estimate.customer
    render layout: "document"
  end

  #Método que adiciona o cartão do customer na square
  def add_card
    result = SquareApi.add_card(params[:customer],params[:nonce])

    if result.success?
      redirect_to nonce_square_api_index_path(estimate: params[:estimate]), notice: "Card add successful"
    elsif result.error?
      redirect_to nonce_square_api_index_path(estimate: params[:estimate]), notice: result.errors
    end
  end

  def process_payment
    #binding.pry
    result = SquareApi.create_payment(params[:nonce],1000)
  end

end