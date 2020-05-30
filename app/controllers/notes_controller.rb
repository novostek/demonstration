class NotesController < ApplicationController
  #load_and_authorize_resource
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  def index
    @q = Note.all.ransack(params[:q])
    @notes = @q.result.page(params[:page])
  end

  # GET /notes/1
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  def create
    @note = Note.new(note_params)

    if @note.save
      redirect_to @note, notice: t('notice.note.created')
    else
      render :new
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      redirect_to @note, notice: t('notice.note.updated')
    else
      render :edit
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy

    redirect_back(fallback_location: root_path, notice: t('notice.note.deleted'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def note_params
      params.require(:note).permit(:title, :text, :private, :origin, :origin_id)
    end
end
