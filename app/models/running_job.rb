# == Schema Information
#
# Table name: running_jobs
#
#  id         :uuid             not null, primary key
#  complete   :boolean
#  redirect   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class RunningJob < ApplicationRecord
end
