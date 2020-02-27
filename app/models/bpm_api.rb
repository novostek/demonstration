module BpmApi

  #Define BPM URL provider
  def self.provider(user=nil, password=nil)
    "http://#{user || credentials[:user] }:#{password || credentials[:password]}@localhost:8080/engine-rest/"
  end

  #Define default credentials
  def self.credentials
    {user: "demo", password: "demo"}
  end

  #Method to return defaults api's calls
  def self.call(endereco, method=:get, params={}, credentials={user: nil, password:nil})
    if method == :get
      params_url  = URI.unescape(params.to_param)
      endereco = provider(credentials[:user], credentials[:password]) + endereco +"?"+ params_url
      call = RestClient.send(method, endereco)
    else
      endereco = provider(credentials[:user], credentials[:password]) + endereco
      call = RestClient.send(method, endereco, params.to_json, content_type: :json)
    end
    if call.code == 204
      return {result: true}
    end
    return JSON.parse(call, symbolize_names: true)
  end

  #Start a Process Instance
  def self.start_instance(process, variables)
    if variables.nil?
      call("process-definition/key/#{process}/start", :post,{})
    else
      variables_f =format_variables_to_submit(variables)
      return call("process-definition/key/#{process}/start", :post,
           {
               variables: variables_f
           })
    end
  end

  #Complete a Task
  def self.complete_task(task, variables)
    if variables.nil?
      call("task/#{task}/complete", :post,{})
    else
      variables_f =format_variables_to_submit(variables)
      call("task/#{task}/complete", :post,
           {
               variables: variables_f
           })
    end
  end

  #Format the variables from rails form to Camunda format
  def self.format_variables_to_submit(variables)
    variables_f = {}
    variables.keys.map do |key|
      variables_f[key] = {value: variables["#{key}"]}
    end
    variables_f
  end

  #Get a process instance data
  def self.get_instance(id)
    general =  call("history/process-instance/#{id}")
    variables_f = process_variable(id, general)
    {general: general, variables: variables_f}
  end

  #Return a formatted variables from a process instance id
  def self.process_variable(id, data=nil)
    variables =  call("history/variable-instance/", :get, {
        processInstanceId: id
    })
    if data.nil?
      instance = call("history/process-instance/#{id}")
    else
      instance = data
    end
    fields = get_xml_variables(instance[:processDefinitionId])
    variables_f = []
    variables.map do |variable|
      field = fields[:form]["#{variable[:name]}"]
      if field.present?
        name = field[:name]
        category =  field[:properties].present? ? field[:properties][:category] || "string" : "string"
        link = ""
        if category == "reference"
          link = "/#{name.delete('Reference').tableize}/#{variable[:value]}"
        end
        variables_f << {name: name, category: category, value: variable[:value], key: variable[:name], link: link}
      end
    end
    variables_f
  end

  #Get the fields to start a Process Instance by process key
  def self.get_form(process_key)
    get_fields("key/#{process_key}", 'start', "startEvent")
  end

  #Get Fields to complete the Task by Task id
  def self.get_task_form(id)
    task = get_task(id)[:task]
    get_fields(task[:processDefinitionId], task[:taskDefinitionKey])
  end

  #Read the XML diagram to find and return the form fields
  def self.get_fields(process, step, event="userTask")
    response = call("process-definition/#{process}/xml")[:bpmn20Xml].squish!
    if step == "start"
      search = "//bpmn:#{event}"
    else
      search = "//bpmn:#{event}[@id='#{step}']"
    end
    xml = Nokogiri::XML(response)
    fields = xml.xpath(search)
                     .children.xpath('./camunda:formData/camunda:formField').map do |field|
      name = field.attr('label')
      key = field.attr('id')
      value= field.attr('defaultValue')
      properties_f = {}
      properties = field.children.xpath('./camunda:property').map do |property|
        properties_f[:"#{property.attr('id')}"] = property.attr('value')
        {"#{property.attr('id')}": property.attr('value')}
      end
      category = properties_f[:type] || "string"
      {name: name, key: key, value: value, category: category,  properties: properties, properties_f: properties_f}
    end
    fields
  end

  #Read the XML diagram to find and return the variables
  def self.get_xml_variables(process)
    response = call("process-definition/#{process}/xml")[:bpmn20Xml].squish!
    xml = Nokogiri::XML(response)
    fields = xml.xpath('//camunda:formData/camunda:formField').map do |field|
      name = field.attr('label')
      key = field.attr('id')
      value= field.attr('defaultValue')
      properties = field.children.xpath('./camunda:property').map do |property|
        {"#{property.attr('id')}": property.attr('value')}
      end
      {name: name, key: key, value: value, properties: properties}
    end
    form = {}
    fields.map do |f|
      form[f[:key]] = f
    end
    {fields: fields, form: form}
  end

  #Get Instance Activities History
  def self.get_activities(id)
    call(
        "history/activity-instance",
        :get ,
        {
            processInstanceId: id,
            sortBy: "startTime",
            sortOrder: "desc"
        }
    )
  end

  #Get Tasks assignee to the groups from the username
  def self.get_group_tasks(username)
    groups = call("group", :get, {member: username}).map{|a| a[:id]}
    BpmApi.call(
        "task",
        :get,
    { candidateGroups: groups.compact.join(',')}
    )
  end

  #Get task and your variables
  def self.get_task(id)
    task = call("task/#{id}")
    variables = process_variable(task[:processInstanceId])
    {task: task, variables: variables}
  end
end