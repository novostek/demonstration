# == Schema Information
#
# Table name: leads
#
#  id          :uuid             not null, primary key
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
#  index_leads_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#

class Lead < ApplicationRecord
  belongs_to :customer
  has_one :estimate

  extend Enumerize

  enumerize :status, in: [:new, :done, :contacted, :scheduled, :closed], predicates: true

  def as_json(options = {})
    s = super(options)
    s[:customer] = self.customer
    s
  end
end
