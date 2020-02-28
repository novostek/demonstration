class SquareApiController < ApplicationController

  def callback
    render json: {teste: "testendo"}
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