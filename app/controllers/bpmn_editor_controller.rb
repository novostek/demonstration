class BpmnEditorController < ApplicationController
  #load_and_authorize_resource
  # skip_before_action :verify_authenticity_token
  def list
    @list = BpmApi.call("process-definition", :get, {latestVersion: true})
  end

  def editor
    @url = bpm_diagram_with_key_url(key: "key", id: params[:id])
    render layout: false
  end

  def deploy
    begin
      filename = "#{Rails.root}/tmp/bpmn_files/woffice#{DateTime.now.to_i}.bpmn"
      File.open(filename, "w")do |f|
        f.write(params[:xml])
      end

      response =RestClient::Request.execute(
          :method => :post,
          :url => "#{BpmApi.provider}deployment/create",
          :headers => {:content_type => 'multipart/form-data', :accept => 'application/json'},
          :payload => {multipart: true, file: File.new(filename, 'rb') }
      )
      File.delete(filename) if File.exist?(filename)
      render js: "alert('Deployed!')"
    rescue
      render js: "alert('Error, try again later')"
    end
  end
end
