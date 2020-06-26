class ContactsController < ApplicationController
  load_and_authorize_resource
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  def index
    @q = Contact.all.ransack(params[:q])
    @contacts = @q.result.page(params[:page])
  end

  # GET /contacts/1
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      redirect_to @contact, notice: t('notice.contact.created')
    else
      render :new
    end
  end

  # PATCH/PUT /contacts/1
  def update
    @contact.title = params[:contact][:title]
    #@contact.category = params[:contact][:category]
    @contact.main = params[:contact][:main]
    @contact.data = params[:contact][:data]
    #binding.pry
    if @contact.save
      redirect_to "/#{@contact.origin.pluralize.downcase}/#{@contact.origin_id}", notice: t('notice.contact.updated')
    else
      render :edit
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
    redirect_to "/#{@contact.origin.pluralize.downcase}/#{@contact.origin_id}", notice: t('notice.contact.deleted')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contact_params
      params.require(:contact).permit(:category, :title, :value, :origin, :origin_id, :data[:address,:zipcode,:zipcode,:state,:lat,:lng,:city,:email, :ddd,:phone],:main)
    end
end
