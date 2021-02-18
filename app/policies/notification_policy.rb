# frozen_string_literal: true

class NotificationPolicy < ApplicationPolicy
  def index?
    user &&
      record == user
  end

  def show?
    user &&
      record.user == user
  end

  def clear?
    user &&
      record == user
  end
end
