class SquareApi
  require 'square'

  def self.get_key
    Setting.get_value("square_key")
  end

  def self.get_app_id
    Setting.get_value("square_app_id")
  end

  def self.get_transaction(transaction_id)
    client = SquareApi.client

    transactions_api = client.transactions
    location_id = SquareApi.locations.first[:id]

    result = transactions_api.retrieve_transaction(location_id: location_id, transaction_id: transaction_id)

    if result.success?
      return true, result.data
    elsif result.error?
      return false, result.errors
    end


  end

  def self.create_checkout(order, transaction)
    client = SquareApi.client

    checkout_api = client.checkout

    location_id = SquareApi.locations.first[:id]
    body = {}
    body[:idempotency_key] = SecureRandom.uuid
    body[:order] = {}
    body[:order][:reference_id] = "#{order.id}"
    body[:order][:line_items] = []


    body[:order][:line_items][0] = {}
    body[:order][:line_items][0][:name] = "Payemnt of Order N* #{order.code}"
    body[:order][:line_items][0][:quantity] = '1'
    body[:order][:line_items][0][:base_price_money] = {}
    body[:order][:line_items][0][:base_price_money][:amount] = (transaction.value*100).to_i
    body[:order][:line_items][0][:base_price_money][:currency] = 'USD'
    # body[:order][:line_items][0][:discounts] = []


    # body[:order][:line_items][0][:discounts][0] = {}
    # body[:order][:line_items][0][:discounts][0][:name] = '7% off previous season item'
    # body[:order][:line_items][0][:discounts][0][:percentage] = '7'


    # body[:order][:taxes] = []
    #
    #
    # body[:order][:taxes][0] = {}
    # body[:order][:taxes][0][:name] = 'Sales Tax'
    # body[:order][:taxes][0][:percentage] = '8.5'


    # body[:ask_for_shipping_address] = true
    # body[:merchant_support_email] = 'merchant+support@website.com'
    # body[:pre_populate_buyer_email] = 'example@email.com'
    # body[:pre_populate_shipping_address] = {}
    # body[:pre_populate_shipping_address][:address_line_1] = '1455 Market St.'
    # body[:pre_populate_shipping_address][:address_line_2] = 'Suite 600'
    # body[:pre_populate_shipping_address][:locality] = 'San Francisco'
    # body[:pre_populate_shipping_address][:administrative_district_level_1] = 'CA'
    # body[:pre_populate_shipping_address][:postal_code] = '94103'
    # body[:pre_populate_shipping_address][:country] = 'US'
    # body[:pre_populate_shipping_address][:first_name] = 'Jane'
    # body[:pre_populate_shipping_address][:last_name] = 'Doe'
    if Rails.env.production?
      body[:redirect_url] = "http://woodoffice.herokuapp.com/square_api/callback?transaction=#{transaction.id}"
    else
      body[:redirect_url] = "http://f5bbe7ed.ngrok.io/square_api/callback?transaction=#{transaction.id}"
    end




    result = checkout_api.create_checkout(location_id: location_id, body: body)

    if result.success?
      return true, result.data
    elsif result.error?
      return false, result.errors
    end
  end


  def self.create_payment(nonce, value)
    client = SquareApi.client

    request_body = {
        :source_id => nonce,
        :amount_money => {
            :amount => value,
            :currency => 'USD'
        },
        :reference_id => '123456',
        :idempotency_key => SecureRandom.uuid
    }

    resp = client.payments.create_payment(body: request_body)

    if resp.success?
      @payment = resp.data.payment
    else
      @error = resp.errors
    end
  end

  def self.client
    #env = Rails.env.production? ? "production" : "sandbox"
    client = Square::Client.new(
        access_token: SquareApi.get_key,
        environment: "sandbox"
    )
  end

  def self.locations
    client = SquareApi.client

    # Call list_locations method to get all locations in this Square account
    result = client.locations.list_locations

    # Call the #success? method to see if the call succeeded
    if result.success?
      # The #data Struct contains a list of locations
      locations = result.data.locations

      # Iterate over the list
      locations.each do |location|
        # Each location is represented as a Hash
        location.each do |key, value|
          puts "#{key}: #{value}"
        end
      end
    else
      # Handle the case that the result is an error.
      warn 'Error calling LocationsApi.listlocations ...'

      # The #errors method returns an Array of error Hashes
      result.errors.each do |key, value|
        warn "#{key}: #{value}"
      end
    end

  end

end