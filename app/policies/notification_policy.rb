# frozen_string_literal: true

class NotificationPolicy < ApplicationPolicy
  def show?
    user &&
      record.user == user
  end

  def clear?
    user &&
      record == user
  end
end
