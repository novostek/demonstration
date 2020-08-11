class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include Bpmn

  def generate_code
    temp_model = self.model_name.name.classify.constantize
    loop do
      code = "#{Time.now.year}#{SecureRandom.random_number(999999)}"
      break code unless temp_model.where(code: code).exists?
    end
  end
end
