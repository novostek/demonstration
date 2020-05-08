# == Schema Information
#
# Table name: suppliers
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Supplier < ApplicationRecord

  has_many :notes, -> { where origin: :Supplier }, primary_key: :id, foreign_key: :origin_id
  has_many :contacts, -> { where origin: :Supplier }, primary_key: :id, foreign_key: :origin_id
  has_many :document_files, -> { where origin: :Supplier }, primary_key: :id, foreign_key: :origin_id

  accepts_nested_attributes_for :notes, allow_destroy: true
  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :document_files, allow_destroy: true


  #Método que retorna o nome do supplier
  def to_s
    self.name
  end

  #Método que retorna um array dos objetos para usar nos combos
  def self.to_select
    all.map{|a| [a.name,a.id]}
  end
end

