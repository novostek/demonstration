class EstimatesController < ApplicationController
  before_action :set_estimate, only: [:show, :edit, :update, :destroy,:send_mail,:estimate_signature]
  before_action :set_combos, only: [:step_one]
  # skip_forgery_protection
  # GET /estimates
  def index
    @q = Estimate.all.ransack(params[:q])
    @estimates = @q.result.page(params[:page])
  end

  # GET /estimates/1
  def show
  end
  
  def estimate_signature
    #verifica se foi assinado para criar a order
    if params[:sign].present?
      if !@estimate.order.present?
        order = Order.new
        if order.save
          @estimate.update(order_id: order.id)

          #cria os purchases
          @estimate.product_estimates.each do |p|
            #verifica se o produto pertence ao catalogo
            if p.product.present?
              #begin
                purchase = Purchase.find_or_create_by(order_id: order.id, supplier_id: p.product.supplier.id)
                ProductPurchase.create(product: p.product, purchase: purchase, unity_value: p.unitary_value, quantity: p.quantity, value: p.value, custom_title: p.custom_title)
              # rescue
              #end

            else #custom products
              purchase = Purchase.find_or_create_by(order_id: order.id, supplier_id: nil)
              ProductPurchase.create(purchase: purchase, unity_value: p.unitary_value, quantity: p.quantity, value: p.value, custom_title: p.custom_title)
            end

          end
        end
      end
    end
    @signature = Signature.new
    @signature.origin = "Estimate"
    @signature.origin_id = @estimate.id
    render layout: "clean"
  end

  def send_mail
    @estimate.link = "http://localhost:3000/estimates/#{@estimate.id}/estimate_signature"
    SendGridMail.send_mail(params[:template],[@estimate,@estimate.customer],params[:subject],params[:emails])
    redirect_to "/estimates/#{@estimate.id}/view", notice: "Mail Sent"
  end

  # GET /estimates/new
  def new
    @estimate = Estimate.new
  end

  # GET /estimates/1/edit
  def edit
  end

  # POST /estimates
  def create
    @estimate = Estimate.new(estimate_params)

    if @estimate.save
      redirect_to @estimate, notice: 'Estimate foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /estimates/1
  def update
    if @estimate.update(estimate_params)
      redirect_to products_estimate_path(@estimate.id), notice: 'Estimate foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /estimates/1
  def destroy
    @estimate.destroy
    redirect_to estimates_url, notice: 'Estimate foi apagado com sucesso.'
  end

  def step_one
    @estimate = Estimate.find_or_initialize_by(lead_id: params[:lead_id])
    
    @lead = Lead.find(params[:lead_id])
    render :step_1
  end

  def create_step_one
    estimate = Estimate.find_or_initialize_by(lead_id: params[:lead_id])
    estimate.code = params[:estimate][:code]
    estimate.title = params[:estimate][:title]
    estimate.description = params[:estimate][:description]
    estimate.location = params[:estimate][:location]
    estimate.latitude = params[:estimate][:latitude]
    estimate.longitude = params[:estimate][:longitude]
    estimate.sales_person_id = params[:estimate][:sales_person_id]
    estimate.lead_id = params[:lead_id]
    estimate.status = 'new'
    estimate.total = 0.0
    estimate.category = 'test'

    if estimate.save()
      redirect_to schedule_estimate_path(estimate.id)
    end
  end
  
  def schedule
    @estimate = Estimate.find(params[:id])
    @workers = Worker.all
    @schedules = @estimate.schedules
    render :schedule
  end

  def create_schedule
    estimate = Estimate.find(params[:estimate_id])

    schedule_obj = {
      :title => params[:title],
      :schedule_id => params[:schedule_id],
      :category => params[:category],
      :description => params[:description],
      :start_at => params[:start_at],
      :end_at => params[:end_at],
      :color => params[:color],
      :worker_id => params[:worker_id],
      :origin => "Estimate",
      :origin_id => estimate.id
    }

    schedule = Schedule.new_schedule(schedule_obj)

    render json: schedule
  end

  def delete_schedule
    schedule = Schedule.find_by(origin: params[:origin], origin_id: params[:estimate_id], worker_id: params[:worker_id])

    schedule.destroy
  end
  
  def products
    estimate = Estimate.includes(:lead).find(params[:id])

    @estimate = estimate
    @products = Product.all

    render :products
  end

  def create_products_estimates
    #tem areas e produtos
    product_estimate = params[:productEstimate]
    begin
      product_estimate.each do |pe|
        mp = MeasurementProposal.create()
        pe["areas"].each do |area|
          AreaProposal.create_or_find_by(measurement_area_id: area, measurement_proposal_id: mp.id)
        end
        pe["products"].each do |product|
          ProductEstimate.create_or_find_by(
            product_id: product["product_id"],
            quantity: product["qty"],
            unitary_value: product["price"],
            discount: product["discount"],
            tax: 0,
            value: product["total"],
            measurement_proposal_id: mp.id
          )
        end
      end
    rescue
      render json: {status: :internal_server_error}
    else
      render json: {status: :ok}
    end
  end

  def view_estimate
    @estimate = Estimate.find(params[:estimate_id])

    begin
      @email_customer = @estimate.customer.contacts.where(category: :email).first.data["email"]
    rescue
      @email_customer = ""
    end

    begin
      @templates = SendGridMail.get_templates["templates"].map{|a| [a["name"],a["id"]]}
    rescue
      @templates = []
    end

    render :estimate_view
  end

  private
    #Método que carrega os objetos de seleção
    def set_combos
      @workers = Worker.to_select
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_estimate
      @estimate = Estimate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def estimate_params
      params.require(:estimate).permit(
          :code, :title, :worker_id, :status, :description, :location, 
          :latitude, :longitude, :category, :order_id, :price, :tax, 
          :tax_calculation, :lead_id, :bpmn_instance, :current, :total,
          measurement_areas_attributes: [
            :id, :estimate_id, :name, :description, :_destroy,
            measurements_attributes: [
              :id, :length, :width, :height, :_destroy
            ]
          ])
    end
end
