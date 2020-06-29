class EstimatesController < ApplicationController
  load_and_authorize_resource except: [:estimate_signature, :create_products_estimates, :create_step_one, :create_schedule,:delete_schedule]
  before_action :set_estimate, only: [:send_grid_mail, :show, :edit, :update, :destroy, :cancel, :reactivate, :send_mail,:estimate_signature, :tax_calculation, :taxpayer, :create_products_estimates,:new_note, :new_document,:create_order]
  before_action :set_combos, only: [:step_one, :products]
  # skip_forgery_protection
  # GET /estimates

  def index
    @q = Estimate.all.order(created_at: :desc).ransack(params[:q])
    @estimates = @q.result.page(params[:page])
  end

  # GET /estimates/1
  def show
    @hidden_fields = Setting.get_value('hidden_measurement_fields')
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

  #Método que insere uma nota
  def new_note
    note = Note.new
    note.title = params[:title]
    note.text = params[:text]
    note.origin = "Estimate"
    note.origin_id = @estimate.id
    if note.save
      redirect_to "/estimates/#{@estimate.id}/view", notice: "#{t 'note_create'}"
    else
      redirect_to   "/estimates/#{@estimate.id}/view", alert: "#{note.errors.full_messages.to_sentence}"
    end
  end

  #método que insere um novo documento
  def new_document
    doc = DocumentFile.new
    doc.title = params[:title]
    doc.file = params[:file]
    doc.description = params[:description]
    doc.origin = "Estimate"
    doc.origin_id = @estimate.id
    if doc.save
      redirect_to "/estimates/#{@estimate.id}/view", notice: "#{t 'doc_create'}"
    else
      redirect_to "/estimates/#{@estimate.id}/view", alert: "#{doc.errors.full_messages.to_sentence}"
    end

  end

  def create_order
    @estimate.create_order
    @estimate.update(status: :ordered)
    redirect_to schedule_order_path(@estimate.order)
  end

  def estimate_signature
    @view = params[:view]
    @hidden_fields = Setting.get_value('hidden_measurement_fields')
    #verifica se foi assinado para criar a order
    if params[:sign].present?
      # Cria a order caso não seja change_order
      if @estimate.estimate?
        @estimate.create_order
        @estimate.update(status: :ordered)
      else #change_order
        @estimate.update(status: :ordered)
        @estimate.order.estimates.where.not(id: @estimate.id).update_all(status: :cancelled)
        @estimate.order.update(status: :change_approved)
        begin
          estimate_doc = @estimate.document_files.last.dup
          sestimate_doc.title = "Change Order Signature"
          estimate_doc.origin = "Order"
          estimate_doc.origin_id = @estimate.order.id
          estimate_doc.file = @estimate.document_files.last.file
          estimate_doc.save
        rescue
        end

      end
      if @estimate.payment_approval
        redirect_to nonce_square_api_index_path(estimate: @estimate.id)
        return
      end
    end

    #cria a assinatura para o formulário
    @signature = Signature.new
    @signature.origin = "Estimate"
    @signature.origin_id = @estimate.id
    #render "estimate_signature_new", layout: "clean"]
    #if @estimate.payment_approval

      #else
    render layout: "document"
      #end
  end

  #Método que envia o email do estimate via woffice
  def send_mail
    if !params[:subject].present? or !params[:emails].present?
      redirect_to "/estimates/#{@estimate.id}/view", notice: t('notice.estimate.inform_all_fields')
    else
      @estimate.link = "#{Setting.url}/estimates/#{@estimate.id}/estimate_signature"
      DocumentMailer.with(estimate: @estimate, emails: params[:emails]).send_estimate_mail.deliver_now
      redirect_to "/estimates/#{@estimate.id}/view", notice: t('notice.estimate.mail_sent')
    end

  end

  #Método que envia os emails utilizando o send-grid
  def send_grid_mail

    if !params[:template].present? or !params[:subject].present? or !params[:emails].present?
      redirect_to "/estimates/#{@estimate.id}/view", notice: t('notice.estimate.inform_all_fields')

    else

      if !Rails.env.production?
        @estimate.link = "http://localhost:3000/estimates/#{@estimate.id}/estimate_signature"
      else
        @estimate.link = "#{Setting.url}/estimates/#{@estimate.id}/estimate_signature"
      end

      SendGridMail.send_mail(params[:template],[@estimate,@estimate.customer, @estimate.order],params[:subject],params[:emails])
      #redirect_to "/estimates/#{@estimate.id}/view", notice: t('notice.estimate.mail_sent')
      redirect_back(fallback_location: root_path,notice: t('notice.estimate.mail_sent'))
    end
  end

  # GET /estimates/new
  def new
    @estimate = Estimate.new
  end

  # GET /estimates/1/edit
  def edit
    if @estimate.ordered?
      redirect_to "/estimates/#{@estimate.id}/view", notice: t('notice.estimate.already_ordered')
    end
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

  def clone
    begin
      estimate = Estimate.find(params[:id])

      lead = estimate.lead.dup
      lead.save

      new_estimate = estimate.dup
      new_estimate.code = Estimate.last.code.to_i + 1
      new_estimate.status = :new
      new_estimate.lead = lead
      new_estimate.order_id = nil
      new_estimate.price = 0
      new_estimate.tax = 0
      new_estimate.save


      estimate.measurement_areas.each do |ma|
         #duplica measurement_areas
         new_ma = ma.dup
         new_ma.estimate_id = new_estimate.id
         new_ma.save
 
         #cria as measurements
         ma.measurements.each do |m|
           new_m = m.dup
           new_m.measurement_area_id = new_ma.id
           new_m.save
         end
      end

      redirect_to products_estimate_path( new_estimate.id), notice: t('notice.estimate.cloned')
    rescue StandardError => e
      redirect_back(fallback_location: root_path, notice: t('notice.estimate.clone_error'))
    end
  end

  def step_one
    @estimate = Estimate.find_or_initialize_by(lead_id: params[:lead_id])
    if @estimate.new_record?
      address= @estimate.customer.get_main_address
      if address.present?
        @estimate.location = address.data["address"]
        @estimate.latitude = address.data["lat"]
        @estimate.longitude = address.data["lng"]
      end
      @estimate.description = @estimate.lead.description
    end
    if @estimate.ordered?
      redirect_to "/estimates/#{@estimate.id}/view", notice: t('notice.estimate.already_ordered')
      return
    end

    @worker = Worker.new

    @lead = Lead.find(params[:lead_id])
    add_breadcrumb I18n.t("activerecord.models.estimates"), estimates_path
    add_breadcrumb I18n.t("breadcrumbs.step_one"), "/estimates/step_one/#{params[:lead_id]}"
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
    estimate.category = :estimate

    if estimate.save()
      redirect_to schedule_estimate_path(estimate.id)
    end
  end

  def schedule
    @estimate = Estimate.find(params[:id])
    @workers = Worker.where(active: true)
    @schedules = Schedule.where('start_at >= ?', (Time.now - 7.days).strftime('%Y-%m-%d'))
    add_breadcrumb I18n.t("activerecord.models.estimates"), estimates_path
    add_breadcrumb I18n.t("activerecord.models.schedules"), schedule_estimate_path(@estimate)
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
        :origin_id => estimate.id,
        :send_mail => params[:send_mail]
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
    @categories = ProductCategory.to_select
    @suppliers = Supplier.to_select
    @formulas = CalculationFormula.to_select

    add_breadcrumb I18n.t("activerecord.models.estimates"), estimates_path
    add_breadcrumb I18n.t("activerecord.models.products"), products_estimate_path(@estimate)

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
          if !product['name'].empty?
            p_estimate = !product["product_id"] == 0 ? ProductEstimate.find_or_initialize_by(product_id: product["product_id"], measurement_proposal_id: mp.id) : ProductEstimate.find_or_initialize_by(custom_title: product["name"], measurement_proposal_id: mp.id)
            p_estimate.quantity = product["qty"].to_f
            p_estimate.unitary_value = product["price"].to_f
            p_estimate.discount = product["discount"].to_f
            p_estimate.tax = product["tax"]
            p_estimate.value = product["total"].to_f
            p_estimate.save()
          end
        end
      end
      
      @estimate.calculate_tax_values
    rescue StandardError => e
      render json: {status: :internal_server_error, message: e.backtrace.inspect  }
    else
      render json: {status: :ok}
    end
  end

  def view_estimate
    @estimate = Estimate.find(params[:estimate_id])
    @hidden_fields = Setting.get_value('hidden_measurement_fields')
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

    add_breadcrumb I18n.t("activerecord.models.estimates"), estimates_path
    add_breadcrumb I18n.t("breadcrumb.show"), "/estimates/#{params[:estimate_id]}/view"

    render :estimate_view
  end

  def tax_calculation
    #@estimate.tax_calculation = CalculationFormula.find params[:tax_calculation]
    @estimate.tax_calculation_id = CalculationFormula.find(params[:tax_calculation]).id
    @estimate.save
  end

  def taxpayer
    @estimate.taxpayer = params[:taxpayer]
    @estimate.save
  end

  def cancel
    @estimate.status = :cancelled
    @estimate.save

    redirect_to view_estimates_path(@estimate), notice: "#{t 'notice.estimate.cancelled'}"
  end

  def reactivate
    @estimate.status = :new
    @estimate.save

    redirect_to view_estimates_path(@estimate), notice: "#{t 'notice.estimate.reactivated'}"
  end

  def see_price
    #this is only to set permissions
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
        :tax_calculation, :lead_id, :bpmn_instance, :current, :total, :taxpayer,
        measurement_areas_attributes: [
            :id, :estimate_id, :name, :description, :_destroy,
            measurements_attributes: [
                :id, :length, :width, :height, :square_feet, :_destroy
            ]
        ])
  end
end
