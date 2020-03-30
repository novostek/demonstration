class BpmController < ApplicationController
  load_and_authorize_resource
  before_action :get_my_tasks, only:[:tasks, :assignee_tasks]
  before_action :get_task, only:[:task, :complete_task, :task_information, :fix_task]
  before_action :set_bpm_user
  before_action :cors_set_access_control_headers, only: [:diagram]
  def start_process
    @form_fields = BpmApi.get_form(params[:process])
  end

  def tasks
  end

  def assignee_tasks
    respond_to do |format|
      format.json {render json: @tasks}
      format.js {
        @tab_name= "assignee"
        render :show_tasks
      }
    end
  end

  def assignee_group_tasks
    @tasks = BpmApi.get_group_tasks(@bpm_user)
    respond_to do |format|
      format.json {render json: @tasks}
      format.js {
        @tab_name= "group"
        render :show_tasks
      }
    end
  end

  def task
    respond_to do |format|
      format.html
      format.js
    end
  end

  def task_information
    respond_to do |format|
      format.json {render json: @task}
      format.js
    end
  end

  def assignee
    begin
      if params[:instance] == "claim"
        BpmApi.call("task/#{params[:id]}/claim", :post, {userId: @bpm_user})
      elsif params[:instance] == "unclaim"
        BpmApi.call("task/#{params[:id]}/unclaim", :post, {})
      else
        BpmApi.call("task/#{params[:id]}/assignee", :post, {userId: params[:instance]})
      end
    rescue
    end
    redirect_to bpm_task_path(params[:id])
  end

  def complete_task
      @form_fields = BpmApi.get_task_form(params[:id])
  end

  def fix_task
    @response  = BpmApi.complete_task(params[:id], params[:variables])
    redirect_to process_path(id: @task[:task][:processInstanceId])
  end

  def create_instance
    @response  = BpmApi.start_instance(params[:process], params[:variables])
    redirect_to process_path(id: @response[:id])
  end

  def instance
    @data = BpmApi.get_instance(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def process_activity
    @activities = BpmApi.get_activities(params[:id])
    respond_to do |format|
      format.json {render json: @activities}
      format.js
    end
  end

  def diagram
    if params[:key].present?
      @url = "process-definition/#{params[:key]}/#{params[:id]}/xml"
    else
      @url = "process-definition/#{params[:id]}/xml"
    end
    respond_to do |format|
      format.xml {
        @diagram = BpmApi.call(@url)
        render json: @diagram[:bpmn20Xml]
      }
      format.js{
        @url = "/bpm/diagram/#{params[:id]}.xml"
        begin
        if params[:instance].present?
          @tasks = BpmApi.call(
              "history/activity-instance",
              :get ,
              {
                  processInstanceId: params[:instance],
                  sortBy: "startTime",
                  sortOrder: "desc",
                  maxResults: 10
              }
          )
        end
        rescue
        end
      }
    end
  end

  def comments
    @comments = ProcessComment.where(process_id: params[:id]).order(id: :desc)
    respond_to do |format|
      format.json {render json: @comments}
      format.js
    end
  end

  def callback
    binding.pry
  end

  private
  def get_my_tasks
    @tasks = BpmApi.call(
        "task",
        :get,
        { assignee: @bpm_user}
    )
  end

  def get_task
    @task = BpmApi.get_task(params[:id])
  end

  def set_bpm_user
    @bpm_user = "lucascunha" #current_user.bpm_username
  end
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, PATCH, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
end
