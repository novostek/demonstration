class ProductCategory < ApplicationRecord


  before_save :slug_namespace


  #Método que executa slugfy para o namespace caso seja vazio
  def slug_namespace
    if self.namespace.blank?
      self.namespace = self.name.parameterize
    end
  end
end
