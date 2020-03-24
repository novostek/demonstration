class SchedulesController < ApplicationController

  def index
    @schedules = Schedule.all
  end

  def update_hour_cost

    schedule = Schedule.find(params[:schedule])
    schedule.hour_cost = params[:hour_cost]
    schedule.save
    redirect_to params[:redirect], notice: "Hour cost updated"
  end

  def redirect_schedule
    if params[:origin].present? and !params[:origin].blank?
      if params[:origin] == "Estimate"
        redirect_to "/#{params[:origin].pluralize.downcase}/#{params[:origin_id]}/view"
      else
        redirect_to "/#{params[:origin].pluralize.downcase}/#{params[:origin_id]}"
      end

    else
      redirect_to schedules_path
    end

  end

  def load_notes
    $schedule = Schedule.find(params[:schedule])
    @notes = Note.where(origin: "Schedule", origin_id: params[:schedule], private: nil)
    @documents = DocumentFile.where(origin: "Schedule", origin_id: params[:schedule])
    render "workers/load_notes.js"
  end


  #Método que insere uma nota
  def new_note
    #binding.pry
    note = Note.new
    note.title = params[:title]
    note.text = params[:text]
    note.origin = "Schedule"
    note.origin_id = $schedule.id
    note.private = params[:private] || nil
    if note.save
      redirect_to params[:redirect], notice: "#{t 'note_create'}"
    else
      redirect_to params[:redirect], alert: "#{note.errors.full_messages.to_sentence}"
    end
  end

  #método que insere um novo documento
  def new_document
    doc = DocumentFile.new
    doc.title = params[:title]
    doc.file = params[:file]
    doc.description = params[:description]
    doc.origin = "Schedule"
    doc.origin_id = $schedule.id
    if doc.save
      redirect_to params[:redirect], notice: "#{t 'doc_create'}"
    else
      redirect_to params[:redirect], alert: "#{doc.errors.full_messages.to_sentence}"
    end
  end

  def delete_schedule
    schedule = Schedule.find(params[:schedule])
    if schedule.destroy
      redirect_to params[:redirect], notice: "Schedule deleted"
    else
      redirect_to params[:redirect], alert: "#{schedule.errors.full_messages.to_sentence}"
    end

  end

end