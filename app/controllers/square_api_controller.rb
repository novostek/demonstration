class SquareApiController < ApplicationController

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

  def process_payment
    #binding.pry
    result = SquareApi.create_payment(params[:nonce],1000)
  end

end