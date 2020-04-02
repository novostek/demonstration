class TransactionCategoriesController < ApplicationController
  #load_and_authorize_resource
  before_action :set_transaction_category, only: [:show, :edit, :update, :destroy]

  # GET /transaction_categories
  def index
    @q = TransactionCategory.all.ransack(params[:q])
    @transaction_categories = @q.result.page(params[:page])
  end

  # GET /transaction_categories/1
  def show
  end

  # GET /transaction_categories/new
  def new
    @transaction_category = TransactionCategory.new
  end

  # GET /transaction_categories/1/edit
  def edit
  end

  # POST /transaction_categories
  def create
    @transaction_category = TransactionCategory.new(transaction_category_params)

    if @transaction_category.save
      redirect_to @transaction_category, notice: 'Transaction category foi criado com sucesso'
    else
      render :new
    end
  end

  # PATCH/PUT /transaction_categories/1
  def update
    if @transaction_category.update(transaction_category_params)
      redirect_to @transaction_category, notice: 'Transaction category foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  # DELETE /transaction_categories/1
  def destroy
    @transaction_category.destroy
    redirect_to transaction_categories_url, notice: 'Transaction category foi apagado com sucesso.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction_category
      @transaction_category = TransactionCategory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_category_params
      params.require(:transaction_category).permit(:name, :description, :color, :namespace)
    end
end
