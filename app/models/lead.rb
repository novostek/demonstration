# == Schema Information
#
# Table name: leads
#
#  id          :uuid             not null, primary key
#  code        :string
#  date        :datetime
#  description :text
#  email       :string
#  phone       :string
#  status      :string
#  via         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :uuid             not null
#
# Indexes
#
#  index_leads_on_code         (code)
#  index_leads_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#

class Lead < ApplicationRecord
  after_create :initialize_code

  belongs_to :customer
  has_one :estimate

  extend Enumerize

  enumerize :status, in: [:new, :done, :contacted, :scheduled, :closed], predicates: true

  def initialize_code
    self.code = self.generate_code
    self.save
  end

  def self.get_new_leads_count
    where("created_at > now() - interval '30 day' AND status = 'new'").count
  end

  def as_json(options = {})
    s = super(options)
    s[:customer] = self.customer
    s
  end
end
