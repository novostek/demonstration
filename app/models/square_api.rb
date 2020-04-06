class SquareApi
  require 'square'


  def self.save_access_token(code)
    o_auth_api = SquareApi.client.o_auth

    body = {}
    body[:client_id] = SquareApi.get_app_id
    body[:client_secret] = SquareApi.oauth_secret
    body[:code] = code
    body[:grant_type] = 'authorization_code'
    result = o_auth_api.obtain_token(body: body)
    #binding.pry
    if result.success?
      s = Setting.find_or_initialize_by(namespace: "square_oauth_access_token")
      s.value = {"value": result.data.access_token }
      s.save

      ss = Setting.find_or_initialize_by(namespace: "square_oauth_refresh_token")
      ss.value = {"value": result.data.refresh_token }
      ss.save
    elsif result.error?
      warn result.errors
    end
  end


  def self.renew_token
    o_auth_api = SquareApi.client.o_auth

    body = {}
    body[:client_id] = SquareApi.get_app_id
    body[:client_secret] = SquareApi.oauth_secret
    body[:refresh_token] = Setting.get_value("square_oauth_refresh_token")
    body[:grant_type] = 'refresh_token'
    result = o_auth_api.obtain_token(body: body)
    #binding.pry
    if result.success?
      s = Setting.find_or_initialize_by(namespace: "square_oauth_access_token")
      s.value = {"value": result.data.access_token }
      s.save
      return result.data.access_token
    elsif result.error?
      warn result.errors
    end
  end

  def self.merchants
    merchants =  SquareApi.client.merchants
    merchants.list_merchants
  end

  def self.oauth_secret
    Setting.get_value("square_oauth_secret")
  end

  def self.get_key
    Setting.get_value("square_key")
  end

  def self.get_app_id
    Setting.get_value("square_app_id")
  end

  def self.get_transaction(transaction_id)
    client =  Square::Client.new(
        access_token: Setting.get_value("square_oauth_access_token"),
        environment: "sandbox"
    )#SquareApi.client

    transactions_api = client.transactions
    location_id = SquareApi.locations.first[:id]

    result = transactions_api.retrieve_transaction(location_id: location_id, transaction_id: transaction_id)
    #binding.pry
    if result.success?
      return true, result.data
    elsif result.error?
      return false, result.errors
    end


  end

  def self.create_checkout(order, transaction)
    client = client = Square::Client.new(
        access_token: SquareApi.renew_token,
        environment: "sandbox"
    )#SquareApi.client

    checkout_api = client.checkout

    location_id = SquareApi.locations.first[:id]
    body = {}
    body[:access_token] = Setting.get_value("square_oauth_access_token")
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

    if Rails.env.production?
      body[:redirect_url] = "http://woodoffice.herokuapp.com/square_api/callback?transaction=#{transaction.id}"
    else
      body[:redirect_url] = "http://e737d500.ngrok.io/square_api/callback?transaction=#{transaction.id}"
    end




    result = checkout_api.create_checkout(location_id: location_id, body: body)
    #binding.pry
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
    client = Square::Client.new(
        access_token: Setting.get_value("square_oauth_access_token"),
        environment: "sandbox"
    )#SquareApi.client

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