# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    user.profiles.each do |perfil|
      perfil.permissions.keys.map do |key|
        perfil.permissions[key].each do |p|
          can ["#{p[0]}".to_sym], key.sub("Controller","").classify.constantize
        end
      end
    end

  end
end
