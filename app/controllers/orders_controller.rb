class OrdersController < ApplicationController
  before_action :set_order, only: [
    :show, :edit, :update, 
    :destroy, :schedule, :create_schedule, 
    :payments, :transaction, :product_purchase]

  # GET /orders
  def index
    @q = Order.all.ransack(params[:q])
    @orders = @q.result.page(params[:page])
  end

  # GET /orders/1
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  def create
    @order = Order.new(order_params)

    if @order.save
      redirect_to product_purchase_order(@order), notice: 'Order was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      redirect_to product_purchase_order_path(@order), notice: 'Order was successfully updated.'
    else
      render payments_order_path(@order), notice: 'There was an error while trying to update the order.'
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order foi apagado com sucesso.'
  end
  
  def schedule
    @schedules = @order.schedules
    @workers = Worker.all
    @estimate = @order.get_current_estimate

    render :order_schedules
  end

  def create_schedule
    schedule_obj = {
      :title => params[:title],
      :schedule_id => params[:schedule_id],
      :code => params[:code],
      :status => params[:status],
      :start_at => params[:start_at],
      :end_at => params[:end_at],
      :color => params[:color],
      :worker_id => params[:worker_id],
      :origin => "Order",
      :origin_id => @order.id
    }

    schedule = Schedule.new_schedule(schedule_obj)

    render json: schedule
  end

  def payments
    @estimate = @order.get_current_estimate

    render :order_payments
  end

  def product_purchase
    @products = Product.all

    render :product_purchase
  end

  def delete_schedule
    schedule = Schedule.find_by(origin: params[:origin], origin_id: params[:order_id], worker_id: params[:worker_id])

    schedule.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(
        :code, :status, :bpmn_instance, :start_at, :end_at,
        transactions_attributes: [
          :id, :origin, :origin_id, :value, :payment_method, :due, :_destroy
        ])
    end
end
