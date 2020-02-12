class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /customers
  def index
    @q = Customer.all.ransack(params[:q])
    @customers = @q.result.page(params[:page])
  end

  # GET /customers/1
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      redirect_to @customer, notice: 'Customer foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /customers/1
  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: 'Customer foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /customers/1
  def destroy
    @customer.destroy
    redirect_to customers_url, notice: 'Customer foi apagado com sucesso.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def customer_params
      params.require(:customer).permit(:name, :category, :document_id, :since, :code, :birthdate, notes_attributes:[:id,:origin,:origin_id,:private,:text,:title,:_destroy],
                                       document_files_attributes:[:id,:title,:file,:origin, :origin_id,:esign,:esign_data,:photo,:photo_date,:photo_description,:_destroy],
                                       contacts_attributes:[:id, :category,:origin, :origin_id,:title,{data:[:address,:zipcode,:zipcode,:state,:lat,:lng,:city,:email, :ddd,:phone]},:_destroy])
    end
end
