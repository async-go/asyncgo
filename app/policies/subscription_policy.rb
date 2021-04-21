# frozen_string_literal: true

class SubscriptionPolicy < ApplicationPolicy
  def edit?
    user &&
      user.team == record
  end
end
