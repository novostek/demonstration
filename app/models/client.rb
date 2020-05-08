# == Schema Information
#
# Table name: public.clients
#
#  id          :bigint           not null, primary key
#  name        :string
#  tenant_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Client < ApplicationRecord
  after_create :create_tenant

  def create_tenant
    Apartment::Tenant.create(self.tenant_name)
  end
end
