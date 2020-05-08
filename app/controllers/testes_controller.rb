class TestesController < ApplicationController
  before_action :set_testis, only: [:show, :edit, :update, :destroy]

  # GET /testes
  def index
    @q = Teste.all.ransack(params[:q])
    @testes = @q.result.page(params[:page])
  end

  # GET /testes/1
  def show
  end

  # GET /testes/new
  def new
    @testis = Teste.new
  end

  # GET /testes/1/edit
  def edit
  end

  # POST /testes
  def create
    @testis = Teste.new(testis_params)

    if @testis.save
      redirect_to @testis, notice: 'Teste foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /testes/1
  def update
    if @testis.update(testis_params)
      redirect_to @testis, notice: 'Teste foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /testes/1
  def destroy
    @testis.destroy
    redirect_to testes_url, notice: 'Teste foi apagado com sucesso.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_testis
      @testis = Teste.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def testis_params
      params.require(:testis).permit(:nome)
    end
end
