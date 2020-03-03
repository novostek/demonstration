class SchedulesController < ApplicationController

  def index
    @schedules = Schedule.all
  end

  def redirect_schedule
    if params[:origin].present? and !params[:origin].blank?
      redirect_to "/#{params[:origin].pluralize.downcase}/#{params[:origin_id]}"
    else
      redirect_to schedules_path
    end

  end

end