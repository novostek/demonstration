class SchedulesController < ApplicationController

  def index
    @schedules = Schedule.all
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

end