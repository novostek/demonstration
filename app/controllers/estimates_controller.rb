class EstimatesController < ApplicationController
  before_action :set_estimate, only: [:show, :edit, :update, :destroy,:send_mail,:estimate_signature, :create_products_estimates]
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
          @estimate.update(order_id: order.id, current: true)

          #cria os purchases
          @estimate.product_estimates.each do |p|
            #verifica se o produto pertence ao catalogo
            if p.product.present?
              #begin
              product = p.product
              purchase = Purchase.find_or_create_by(order_id: order.id, supplier_id: product.supplier.id)
              pp = ProductPurchase.find_or_create_by(product: product, purchase: purchase)
              pp.unity_value =  product.cost_price
              pp.quantity =  p.quantity
              pp.value = pp.unity_value * pp.quantity
              pp.custom_title = p.custom_title
              pp.save
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

    #cria a assinatura para o formulário
    @signature = Signature.new
    @signature.origin = "Estimate"
    @signature.origin_id = @estimate.id
    #render "estimate_signature_new", layout: "clean"
    render layout: "clean"
  end

  def send_mail

    if !params[:template].present? or !params[:subject].present? or !params[:emails].present?
      redirect_to "/estimates/#{@estimate.id}/view", notice: "Inform all fields"

    else

      if !Rails.env.production?
        @estimate.link = "http://localhost:3000/estimates/#{@estimate.id}/estimate_signature"
      else
        @estimate.link = "http://woodoffice.herokuapp.com/estimates/#{@estimate.id}/estimate_signature"
      end

      SendGridMail.send_mail(params[:template],[@estimate,@estimate.customer],params[:subject],params[:emails])
      redirect_to "/estimates/#{@estimate.id}/view", notice: "Mail Sent"
    end
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
      redirect_to @estimate
    else
      render :new
    end
  end

  # PATCH/PUT /estimates/1
  def update
    if @estimate.update(estimate_params)
      redirect_to products_estimate_path(@estimate.id)
    else
      render :edit
    end
  end

  # DELETE /estimates/1
  def destroy
    @estimate.destroy
    redirect_to estimates_url
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
    estimate.tax_calculation_id = params[:estimate][:tax_calculation].to_i

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
        mp = MeasurementProposal.find_or_initialize_by(id: pe['proposal_id'])
        mp.save()
        pe["areas"].each do |area|
          ap = AreaProposal.find_or_initialize_by(measurement_area_id: area, measurement_proposal_id: mp.id)
          ap.measurement_area_id = area
          ap.measurement_proposal_id = mp.id
          ap.save()
        end
        pe["products"].each do |product|
          p_estimate = ProductEstimate.find_or_initialize_by(product_id: product["product_id"], measurement_proposal_id: mp.id)
          p_estimate.quantity = product["qty"]
          p_estimate.unitary_value = product["price"]
          p_estimate.discount = product["discount"]
          p_estimate.tax = 0
          p_estimate.value = product["total"]
          p_estimate.save()
        end
      end
    rescue StandardError => e
      render json: {status: :internal_server_error, message: e.backtrace.inspect  }
    else
      render json: {status: :ok}
    end
  end

  def view_estimate
    @estimate = Estimate.find(params[:estimate_id])
    @documents = Document.to_select
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
    @taxes = CalculationFormula.where(tax: true).to_select
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
