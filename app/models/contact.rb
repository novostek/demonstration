# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  category   :string
#  data       :json
#  main       :boolean
#  origin     :string
#  title      :string
#  value      :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin_id  :integer
#

class Contact < ApplicationRecord

  validates :title, :category, presence: true

  extend Enumerize

  enumerize :category, in: [:phone, :address, :email], predicates: true

  validate :validate_data
  before_save :set_main

  def set_main
    if self.main
      Contact.where(origin: self.origin, origin_id: self.origin_id, category: self.category).update_all(main: false)
    end
  end


  def validate_data
    if self.category.present?
      if self.category.phone?
        errors.add("#{ I18n.t 'json_data.phone'}", "#{I18n.t 'is_required'}") if self.data["phone"].blank?
      elsif self.category.email?
        errors.add("#{ I18n.t 'json_data.email'}", "#{I18n.t 'is_required'}") if self.data["email"].blank?
      else
        errors.add("#{ I18n.t 'json_data.address'}", "#{I18n.t 'is_required'}") if self.data["address"].blank?
        errors.add("#{ I18n.t 'json_data.zipcode'}", "#{I18n.t 'is_required'}") if self.data["zipcode"].blank?
        errors.add("#{ I18n.t 'json_data.state'}", "#{I18n.t 'is_required'}") if self.data["state"].blank?
        errors.add("#{ I18n.t 'json_data.city'}", "#{I18n.t 'is_required'}") if self.data["city"].blank?
        errors.add("#{ I18n.t 'json_data.lat'}", "#{I18n.t 'is_required'}") if self.data["lat"].blank?
        errors.add("#{I18n.t  'json_data.lng'}", "#{I18n.t 'is_required'}" ) if self.data["lng"].blank?
      end
    end

  end
end
