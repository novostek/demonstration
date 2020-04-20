class OrdersController < ApplicationController
  before_action :set_order, only: [:order_photos,:create_doc_for_signature,:deliver_products_sign,:deliver_products,:send_sign_mail,:finish,:finish_order_signature,:finish_order,
                                   :show, :edit, :update,
                                   :destroy, :schedule, :create_schedule,
                                   :payments, :transaction, :product_purchase, :new_note,:new_document,:new_contact, :invoice,:invoice_add_payment,:send_invoice_mail,:view_invoice_customer,:costs,:change_order]
  before_action :authenticate_user!, except: [:invoice,:deliver_products_sign,:doc_signature_mail,:doc_signature, :view_invoice_customer]
  #load_and_authorize_resource  except: [:deliver_products_sign,:doc_signature_mail,:doc_signature, :create_schedule, :delete_schedule, :view_invoice_customer]

  def order_photos

  end

  #Método para visualizar o invoice de order
  def invoice
    @transactions = @order.transactions.order(due: :asc).order(id: :asc)
    begin
      @email_customer = @estimate.customer.contacts.where(category: :email, main: true).first.data["email"]
    rescue
      @email_customer = ""
    end
  end

  # def doc_signature
  #   @document = Document.find(params[:document])
  #   @data = @document.data
  #   @template = Liquid::Template.parse(ERB.new(@data).result(binding))
  #   @estimate = @order.current_estimate
  #   render layout: "clean"
  # end
  #
  # def create_doc_for_signature
  #   doc_signature_mail_orders_url(customer_sign: @customer_sign, document: doc.id,doc_name: @document.name)
  # end

  def doc_signature
    @document = DocumentSend.find(params[:document])
    @data = @document.data
    # @template = Liquid::Template.parse(ERB.new(@data).result(binding))
    # @estimate = @order.current_estimate
    render layout: "clean"
  end

  # def doc_signature_mail
  #   @document = Document.find(params[:document])
  #   @data = @document.data
  #   @template = Liquid::Template.parse(ERB.new(@data).result(binding))
  #   @estimate = @order.current_estimate
  #   @signature = Signature.new
  #   @signature.origin = "Order"
  #   @signature.origin_id = @order.id
  #   render layout: "clean"
  # end
  #
  def doc_signature_mail
    @document = DocumentSend.find(params[:document])
    @doc_name = params[:doc_name]
    @customer_sign = params[:customer_sign]
    @data = @document.data
    @template = Liquid::Template.parse(ERB.new(@data).result(binding))
    @signature = Signature.new
    @signature.origin = @document.origin
    @signature.origin_id = @document.origin_id
    render layout: "clean"
  end

  #Método que envia o email para assinatura
  def send_sign_mail


    @document = Document.find(params[:document])
    @data = @document.data

    @template = Liquid::Template.parse(ERB.new(@data).result(binding))
    @estimate = @order.current_estimate
    doc = DocumentSend.new(origin: "Order",origin_id: @order.id, data: @template.render('order' => @order.attributes ,'estimate' => @estimate.attributes, 'measurements' => JSON.parse(@estimate.measurement_areas.to_json), 'products' => JSON.parse(@estimate.product_estimates.to_json), 'customer' => JSON.parse(@estimate.customer.to_json), 'custom' => @params   ) )
    doc.save
    if !params[:sign].present?
      DocumentMailer.with(link: doc_signature_mail_orders_url(document: doc.id,doc_name: @document.name, customer_sign: true) ,subject: params[:subject] , emails: params[:emails], order: @order).sign_order.deliver_now
      redirect_to finish_order_signature_order_path(@order), notice: t('notice.order.mail_sent')
    else
      redirect_to doc_signature_mail_orders_url(document: doc.id,doc_name: @document.name, customer_sign: true)
    end
  end

  #Método que finaliza a order sem a necessidade de assinatura ou photos
  def finish
    @order.update(status: :finished, end_at: Date.today)
    redirect_to @order, notice: t('notice.order.finished')
  end

  #Método que inicializa a finalização da order pelo envio de fotos
  def finish_order
  end

  def deliver_products

    @purchases = @order.purchases
    @documents = Document.to_select
  end

  def deliver_products_sign

    if !params[:ids].present?
      redirect_to deliver_products_order_path(@order), notice: t('notice.order.select_products')
    else

      has_custom_field = false
      @customs = []
      @params = {}
      @document = Document.find(params[:document])
      @estimate = @order.current_estimate
      @data = @document.data


      if !params[:view].present?
        @products = ProductPurchase.where(id: params[:ids])
      else
        @products = ProductPurchase.where(id: JSON.parse(params[:ids]))
      end

      @template = Liquid::Template.parse(ERB.new(@data).result(binding))

      if !params[:view].present?
        doc = DocumentFile.new

        doc.title = @document.name
        doc.origin = "Order"
        doc.origin_id = @order.id

        #cria a imagem temporária da assinatura
        temp = Signature.base64_to_file(params[:signature][:file])
        $temp_img = "/#{temp.path.split("/").last}"

        #cria o PDF
        file = WickedPdf.new.pdf_from_url("#{Rails.configuration.woffice['url']}/orders/#{@order.id}/deliver_products_sign?view=true&document=#{params[:document]}&ids=#{@products.pluck(:id)}")

        # Write it to tempfile
        tempfile = Tempfile.new(['invoice', '.pdf'], Rails.root.join('tmp'))
        tempfile.binmode
        tempfile.write file
        tempfile.close

        doc.file = File.open(tempfile.path)
        doc.save


        @products.update_all(status: :delivered)
        redirect_to deliver_products_order_path(@order), notice: t('notice.order.products_delivered')
      else

        render layout: "clean"
      end
    end
  end


  #Método para caputrar a assinatura da order
  def finish_order_signature
    @documents = Document.where(sub_type: :conclusion).map{|a| [a.name,a.id]}
    @signature = Signature.new
    @signature.origin = "Order"
    @signature.origin_id = @order.id

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
    change_order_estimate.status = :waiting_approval
    change_order_estimate.initialize_code

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
        new_ma.cloned_from = ma.id
        new_ma.save

        #cria as measurements
        ma.measurements.each do |m|
          new_m = m.dup
          new_m.measurement_area_id = new_ma.id
          new_m.save
        end



      end

      #cria as measurement_proposals , area proposal e product_estimate
      current_estimate.area_proposals.group_by(&:measurement_proposal).map do |mp, aps| #ma.measurement_proposals.each do |mp|
        #binding.pry
        new_mp = mp.dup
        new_mp.save

        aps.each do |ap|
            area_proposal = AreaProposal.new
            area_proposal.measurement_area_id = change_order_estimate.measurement_areas.find_by(cloned_from: ap.measurement_area_id).id
            area_proposal.measurement_proposal_id = new_mp.id
            area_proposal.save
        end

        #cria os products_estimate
        mp.product_estimates.each do |pe|
          new_pe = pe.dup
          new_pe.measurement_proposal_id = new_mp.id
          new_pe.save
        end
      end



    end
    @order.status = :awaiting_change_approval
    @order.save
    redirect_to products_estimate_path(change_order_estimate), notice: t('notice.order.change_order_created')
  end

  def change_order_old
    current_estimate = @order.current_estimate
    change_order_estimate = current_estimate.dup
    change_order_estimate.category = :change_order
    change_order_estimate.current = true
    change_order_estimate.status = :waiting_approval
    change_order_estimate.initialize_code

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

          new_mp = mp.dup
          new_mp.save

          area_proposal = AreaProposal.new
          area_proposal.measurement_area_id = new_ma.id
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
    redirect_to products_estimate_path(change_order_estimate), notice: t('notice.order.change_order_created')
  end

  def costs
    @purchases = @order.purchases
    @labor_costs = @order.labor_costs.order(date: :asc)
  end

  def send_invoice_mail
    DocumentMailer.with(subject: params[:subject] , emails: params[:emails], order: @order, link: "#{Setting.url}#{view_invoice_customer_order_path(@order)}").send_invoice.deliver_now
    redirect_to invoice_order_path(@order), notice: t('notice.order.invoice_sent')
  end

  def view_invoice_customer
    @transactions = @order.transactions.order(due: :asc).order(id: :asc)
    render layout: "clean"
  end

  # GET /orders
  def index
    @q = Order.all.ransack(params[:q])
    @orders = @q.result.page(params[:page])
    @orders_month = Order.where("extract(month from start_at) = ? and extract(year from start_at) = ?", Date.today.month, Date.today.year)
    @last_month_orders = Order.where("extract(month from start_at) = ? and extract(year from start_at) = ?", (Date.today - 1.month).month, (Date.today - 1.month).year)
    @transactions = Transaction.where("extract(month from due) = ?", Date.today.month).where(status: :pendent)
    @orders_today = Order.where(start_at: Date.today)


    #calculo de crescimento
    total_passado = @last_month_orders.sum{|a| a.current_estimate.get_total_value}
    if total_passado == 0
      total_passado = 1
    end
    @total_atual = @orders_month.sum{|a| a.current_estimate.get_total_value}
    @resultado = @total_atual - total_passado
    resultado2 = @resultado/total_passado
    @crecimento = resultado2 * 100



    @profit = @total_atual - @orders_month.sum(:total_cost)

    @profit_today = @orders_today.sum{|a| a.current_estimate.get_total_value}  - @orders_today.sum(:total_cost)
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
      redirect_to invoice_order_path(@order),notice: t('notice.order.payment_added')
    else
      redirect_to invoice_order_path(@order),notice: transaction.errors.full_messages.to_sentence
    end

  end



  # GET /orders/1
  def show
    @profit = @order.current_estimate.get_total_value - (@order.total_cost || 0)
    @documents = Document.to_select
    begin
      @email_customer = @estimate.customer.contacts.where(category: :email).first.data["email"]
    rescue
      @email_customer = ""
    end
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
      redirect_to product_purchase_order(@order), notice: t('notice.order.created')
    else
      render :new
    end
  end

  # PATCH/PUT /orders/1
  def update
    # binding.pry
    if @order.update(order_params)

      if !params[:status].present?
        redirect_to product_purchase_order_path(@order), notice: t('notice.order.updated')
      else

        if params[:status] == true #finishing order
          @order.update(status: :finished, end_at: Date.today)
          redirect_to @order, notice: "Order Finished"
        else#go to sign
          redirect_to finish_order_signature_order_path(@order)
        end

      end

    else
      redirect_to payments_order_path(@order), notice: t('notice.order.update_error')
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    redirect_to orders_url, notice: t('notice.order.deleted')
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
        :id, :code, :status, :bpmn_instance, :start_at, :end_at, {photos: []},
        transactions_attributes: [
            :id, :origin, :origin_id, :value, :payment_method, :due,:email, :_destroy
        ])
  end
end
