class ProductPurchasesController < ApplicationController
  before_action :set_product_purchase, only: [:show, :edit, :update, :destroy,:new_note,:new_document,:change_status]
  before_action :authenticate_user!, except: [:create]
  # GET /product_purchases
  def index
    @q = ProductPurchase.all.ransack(params[:q])
    @product_purchases = @q.result.page(params[:page])
  end

  # GET /product_purchases/1
  def show
  end

  #Método que insere uma nota
  def new_note
    note = Note.new
    note.title = params[:title]
    note.text = params[:text]
    note.origin = "ProductPurchase"
    note.origin_id = @product_purchase.id
    if note.save
      redirect_to costs_order_path(@product_purchase.order), notice: "#{t 'note_create'}"
    else
      redirect_to costs_order_path(@product_purchase.order), alert: "#{note.errors.full_messages.to_sentence}"
    end
  end

  def change_status
    @product_purchase.status = params[:status]
    if @product_purchase.save
      render json: {status: "ok", msg: "Changed to #{params[:status]}"}
    else
      render json: {status: "error", msg: @product_purchase.errors.full_message.to_sentence}
    end

  end


  #método que insere um novo documento
  def new_document
    doc = DocumentFile.new
    doc.title = params[:title]
    doc.file = params[:file]
    doc.description = params[:description]
    doc.origin = "ProductPurchase"
    doc.origin_id = @product_purchase.id
    if doc.save
      redirect_to costs_order_path(@product_purchase.order), notice: "#{t 'doc_create'}"
    else
      redirect_to costs_order_path(@product_purchase.order), alert: "#{note.errors.full_messages.to_sentence}"
    end

  end

  # GET /product_purchases/new
  def new
    @product_purchase = ProductPurchase.new
  end

  # GET /product_purchases/1/edit
  def edit
  end

  # POST /product_purchases
  def create
    product_purchase = params[:productPurchase]

    begin
      product_purchase.each do |pp|
        product_purchase = ProductPurchase.find_or_initialize_by(id: pp[:product_purchase_id])
        pp[:product_id].present? ? product_purchase.custom_title = pp[:name] : product_purchase.custom_title = pp[:name]
        product_purchase[:quantity] = pp[:qty]
        product_purchase[:unity_value] = pp[:price]
        product_purchase[:value] = pp[:total]
        product_purchase[:product_id] = pp[:product_id]
        product_purchase[:purchase_id] = pp[:purchase_id]
        product_purchase.save()
      end
    rescue => exception
      render json: {status: :internal_server_error, message: e.backtrace.inspect  }
    else
      render json: {status: :ok  }
    end
    # @product_purchase = ProductPurchase.new(product_purchase_params)

    # if @product_purchase.save
    #   redirect_to @product_purchase, notice: 'Product purchase foi criado com sucesso'
    # else
    #   render :new
    # end
  end

  # PATCH/PUT /product_purchases/1
  def update
    if @product_purchase.update(product_purchase_params)
      redirect = params[:redirect] || params[:product_purchase][:redirect]
      redirect_to redirect, notice: 'Product purchase foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /product_purchases/1
  def destroy
    @product_purchase.destroy
    redirect_to params[:redirect], notice: 'Product purchase was successfully destroyed'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_purchase
      @product_purchase = ProductPurchase.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_purchase_params
      params.require(:product_purchase).permit(:product_id, :purchase_id, :unity_value, :quantity, :value, :status, :custom_title)
    end
end
