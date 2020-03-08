class SignaturesController < ApplicationController
  before_action :set_signature, only: [:show, :edit, :update, :destroy]

  # GET /signatures
  def index
    @q = Signature.all.ransack(params[:q])
    @signatures = @q.result.page(params[:page])
  end

  # GET /signatures/1
  def show
  end

  # GET /signatures/new
  def new
    @signature = Signature.new
  end

  # GET /signatures/1/edit
  def edit
  end

  # POST /signatures
  def create

    @signature = Signature.new(signature_params)
    @signature.file = params[:signature][:file]
    #@signature.file.recreate_versions!

    if @signature.save
      if params[:signature][:sign].present?
        redirect_to "/estimates/#{@signature.origin_id}/estimate_signature?sign=true", notice: 'Signature was successful'
      else
        redirect_to @signature, notice: 'Signature foi criado com sucesso'
      end

    else
      render :new
    end
  end

  # PATCH/PUT /signatures/1
  def update
    @signature.origin = params[:signature][:origin]
    @signature.origin_id = params[:signature][:origin_id]
    @signature.file = params[:signature][:file]
    @signature.file.recreate_versions!
    if @signature.save
      redirect_to @signature, notice: 'Signature foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /signatures/1
  def destroy
    @signature.destroy
    redirect_to signatures_url, notice: 'Signature foi apagado com sucesso.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_signature
      @signature = Signature.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def signature_params
      params.require(:signature).permit(:origin, :origin_id, :file)
    end
end
