class OrdersController < ApplicationController
  before_action :set_order, only: [
    :show, :edit, :update, 
    :destroy, :schedule, :create_schedule, 
    :payments, :transaction, :product_purchase, :new_note,:new_document,:new_contact, :invoice,:invoice_add_payment,:send_invoice_mail,:view_invoice_customer,:costs,:change_order]

  #Método para visualizar o invoice de order
  def invoice
    @transactions = @order.transactions.order(due: :asc).order(id: :asc)
    begin
      @email_customer = @estimate.customer.contacts.where(category: :email, main: true).first.data["email"]
    rescue
      @email_customer = ""
    end
  end

  #Método que gera o change order
  def change_order
    current_estimate = @order.current_estimate
    change_order_estimate = current_estimate.dup
    change_order_estimate.category = :change_order
    change_order_estimate.current = true

    #remove o current estimate
    @order.estimates.update_all(current: false)

    if change_order_estimate.save
      #duplica schedules
      current_estimate.schedules.each do |s|
        new_schedule = s.dup
        new_schedule.origin_id = change_order_estimate.id
        new_schedule.save
      end

      current_estimate.measurement_areas.each do |ma|
        #duplica measurement_areas
        new_ma = ma.dup
        new_ma.estimate_id = change_order_estimate.id
        new_ma.save

        #cria as measurements
        ma.measurements.each do |m|
          new_m = m.dup
          new_m.measurement_area_id = new_ma.id
          new_m.save
        end
        #cria as measurement_proposals , area proposal e product_estimate
        ma.measurement_proposals.each do |mp|
          area_proposal = AreaProposal.new
          area_proposal.measurement_area_id = new_ma.id
          new_mp = mp.dup
          new_mp.save
          area_proposal.measurement_proposal_id = new_mp.id
          area_proposal.save

          #cria os products_estimate
          mp.product_estimates.each do |pe|
            new_pe = pe.dup
            new_pe.measurement_proposal_id = new_mp.id
            new_pe.save
          end
        end
      end
    end
    @order.status = :awaiting_change_approval
    @order.save
    redirect_to products_estimate_path(change_order_estimate), notice: "Change Order created"
  end

  def costs
    @purchases = @order.purchases
    @labor_costs = @order.labor_costs.order(date: :asc)
  end

  def send_invoice_mail
    DocumentMailer.with(subject: params[:subject] , emails: params[:emails], order: @order).send_invoice.deliver_now
    redirect_to invoice_order_path(@order), notice: "Invoice sent"
  end

  def view_invoice_customer
    @transactions = @order.transactions.order(due: :asc).order(id: :asc)
    render "invoice", layout: "clean"
  end

  # GET /orders
  def index
    @q = Order.all.ransack(params[:q])
    @orders = @q.result.page(params[:page])
  end

  def invoice_add_payment
    transaction = Transaction.new
    transaction.origin = params[:origin]
    transaction.origin_id = params[:origin_id]
    transaction.value = params[:value]
    transaction.payment_method = params[:payment_method]
    transaction.due = params[:due]
    transaction.email = params[:email]
    transaction.order = @order
    if transaction.save
      redirect_to invoice_order_path(@order),notice: "Payment add successful"
    else
      redirect_to invoice_order_path(@order),notice: transaction.errors.full_messages.to_sentence
    end

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
      redirect_to payments_order_path(@order), notice: 'There wwwas an error while trying to update the order.'
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
    begin
      @email_customer = @estimate.customer.contacts.where(category: :email).first.data["email"]
    rescue
      @email_customer = ""
    end

    render :order_payments
  end

  def product_purchase
    @products = Product.all
    @estimate = @order.get_current_estimate
    @purchases = Purchase.where(order_id: params[:id])

    render :product_purchase
  end

  def delete_schedule
    schedule = Schedule.find_by(origin: params[:origin], origin_id: params[:order_id], worker_id: params[:worker_id])

    schedule.destroy
  end

  #Método que insere uma nota
  def new_note
    note = Note.new
    note.title = params[:title]
    note.text = params[:text]
    note.origin = "Order"
    note.origin_id = @order.id
    if note.save
      redirect_to @order, notice: "#{t 'note_create'}"
    else
      redirect_to @order, alert: "#{note.errors.full_messages.to_sentence}"
    end


  end



  #método que insere um novo documento
  def new_document
    doc = DocumentFile.new
    doc.title = params[:title]
    doc.file = params[:file]
    doc.description = params[:description]
    doc.origin = "Order"
    doc.origin_id = @order.id
    if doc.save
      redirect_to @order, notice: "#{t 'doc_create'}"
    else
      redirect_to @order, alert: "#{doc.errors.full_messages.to_sentence}"
    end

  end

  #Método que cria um novo contato
  def new_contact
    contact = Contact.new
    contact.title = params[:title]
    contact.category = params[:category]
    contact.data = params[:data]
    contact.origin = "Order"
    contact.origin_id = @order.id
    if contact.save
      redirect_to @order, notice: "#{t 'contact_create'}"
    else
      redirect_to @order, alert: "#{contact.errors.full_messages.to_sentence}"
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(
        :id, :code, :status, :bpmn_instance, :start_at, :end_at,
        transactions_attributes: [
          :id, :origin, :origin_id, :value, :payment_method, :due,:email, :_destroy
        ])
    end
end
