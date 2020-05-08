# == Schema Information
#
# Table name: documents
#
#  id            :bigint           not null, primary key
#  custom_fields :json
#  data          :text
#  description   :text
#  doc_type      :string
#  name          :string
#  sub_type      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Document < ApplicationRecord

  has_many :document_custom_fields

  accepts_nested_attributes_for :document_custom_fields,  allow_destroy: true

  extend Enumerize

  enumerize :doc_type, in: [:estimate, :custom], predicates: true
  enumerize :sub_type, in: [:approval, :conclusion, :other], predicates: true



  #Método que retorna o nome da categoria
  def to_s
    self.name
  end

  #Método que retorna um array dos objetos para utilizar em um select
  def self.to_select
    all.map{|a| [a,a.id]}
  end


end
