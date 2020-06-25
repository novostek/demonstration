class ApiController < ApplicationController
  def woffice_pay_code
    @woffice_token = UserToken.create(user: current_user, active:true).id
    @square_token = SquareApi.get_mobile_token.to_json
    @domain = Setting.url
    result = {
        woffice_token: @woffice_token,
        square_token: @square_token,
        domain: @domain,
        company: @company_name
    }
    qrcode = RQRCode::QRCode.new(result.to_s)
    png = qrcode.as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: 'black',
        file: nil,
        fill: 'white',
        module_px_size: 6,
        resize_exactly_to: false,
        resize_gte_to: false,
        size: 350
    )
    send_data png.to_s , filename: "qrcode.png", type: "image/png", disposition: 'inline', stream: 'true', buffer_size: '4096'
  end

  def order_paid
    begin
      transaction = Transaction.find(params[:id])
      transaction.square_data = params[:square_data]
      transaction.status = :paid
      transaction.payment_method = :woffice_pay
      if transaction.save
        render json: transaction
      else
        render json: {error: "not save"}, status: 422
      end
      rescue
      render json:{error: "We have a problem"}, status: 500
      end
  end

end
