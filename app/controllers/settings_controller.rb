class SettingsController < ApplicationController
  #load_and_authorize_resource
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  # GET /settings
  def index
    @q = Setting.all.ransack(params[:q])
    @settings = @q.result.page(params[:page])
  end

  def atualiza_transactions
    params.reject{|a,b| ["action","commit","controller","redirect","logo"].include? a }.each do |p|
      s = Setting.find_or_initialize_by(namespace: p[0])
      s.value = {"value": p[1] }
      
      s.save
    end

    redirect_to transactions_settings_path, notice: t('notice.setting.updated')
  end

  def atualiza_settings
    params.reject{|a,b| ["action","commit","controller","redirect","logo"].include? a }.each do |p|
      if p[0] != "width" and p[0] != "length" and p[0] != "height" and p[0] != "square_feet"
        s = Setting.find_or_initialize_by(namespace: p[0])
        s.value = {"value": p[1] == "1" ? true : p[1] == "0" ? false : p[1]}
      else
        s = Setting.find_or_initialize_by(namespace: "hidden_measurement_fields")
        if s.value.present?
          s.value["value"]["#{p[0]}"] = p[1] == "1" ? true : false
        else
          s.value = {"value": {}}
          s.value["value"]["#{p[0]}"] = p[1] == "1" ? true : false
        end

      end
      s.save
    end

    if params[:logo].present?
      #binding.pry
      doc = DocumentFile.find_or_initialize_by(origin: "Logo", origin_id: 1)
      doc.title = "Logo"
      doc.file = params[:logo]
      doc.save
      s = Setting.find_or_initialize_by(namespace: "logo")
      s.value = {"value": doc.file.url }
      s.save
    end

    if params[:banner].present?
      #binding.pry
      doc = DocumentFile.find_or_initialize_by(origin: "Banner", origin_id: 1)
      doc.title = "Banner"
      doc.file = params[:banner]
      doc.save

    end
    redirect_to params[:redirect], notice: t('notice.setting.updated')
  end

  def transactions
    @categories = TransactionCategory.all
    @accounts = TransactionAccount.all
  end

  # GET /settings/1
  def show
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  def create
    @setting = Setting.new(setting_params)

    if @setting.save
      redirect_to @setting, notice: t('notice.setting.created')
    else
      render :new
    end
  end

  # PATCH/PUT /settings/1
  def update
    if @setting.update(setting_params)
      redirect_to @setting, notice: t('notice.setting.updated')
    else
      render :edit
    end
  end

  # DELETE /settings/1
  def destroy
    @setting.destroy
    redirect_to settings_url, notice: t('notice.setting.deleted')
  end

  #Render Company Logo
  def company_logo
    #redirect_to Setting.logo
    s = Setting.logo_object
    data = open(s.file.url.gsub('https','http'))
    send_data data.read, filename: s.file.filename, type: s.file.content_type, disposition: 'inline', stream: 'true', buffer_size: '4096'
  end

  #Render Company Banner
  def company_banner
    #redirect_to Setting.logo
    s = Setting.banner_object
    data = open(s.file.url.gsub('https','http'))
    send_data data.read, filename: s.file.filename, type: s.file.content_type, disposition: 'inline', stream: 'true', buffer_size: '4096'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def setting_params
      params.require(:setting).permit(:namespace, :value)
    end
end
