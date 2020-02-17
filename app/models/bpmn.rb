module Bpmn
  def self.included(klass)
    klass.extend ClassMethods
  end

  #Start a default instance process
  def start_default_process(variables={})
    instance = start_process("#{self.model_name.singular}_default", variables)
    self.update(bpm_instance: instance[:id])
    instance
  end

  #Start a referenced instance process
  def start_process(process_name, variables={})
    #Get a setting by the process_name
    setting = Setting.find_by_namespace("#{process_name}_bpmn_process")

    if setting.present?
      #Fix nil problems
      variables = {} if variables.nil?
      data = setting.value

      #Insert this reference in the variable
      variables["#{self.model_name.singular}Reference"] = "#{self.id}"

      #If have attributes, insert in the variables
      if data['attributes'].present?
        data['attributes'].map do |a|
          variables[a['bpm_field']] = self.send(a['app_field'])
        end
      end
      #Run the API method
      return BpmApi.start_instance(data['key'], variables)
    end
    {}
  end

  #Get Instances Processes
  def instance_processes
    BpmApi.call(
        "process-instance",
        :get,
        {
            variables: "#{self.model_name.singular}Reference_eq_#{self.id}"
        }    )
  end


  module ClassMethods
    #Get fields for start default process
    def bpmn_fields
      setting = Setting.find_by_namespace("#{self.model_name.singular}_default_bpmn_process")
      if setting.present?
        data = setting.value
        fields = BpmApi.get_form(data['key'])
        if data['attributes'].present?
          default_list = []
          data['attributes'].map{|a| default_list << a['bpm_field']}
          fields.delete_if { |a| default_list.include?(a['key'])}
          return fields
        end
      end
      []
    end
  end
end