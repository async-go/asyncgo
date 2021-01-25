# frozen_string_literal: true

module Users
  class NotificationPolicy < ApplicationPolicy
    def show?
      user &&
        record.user == user
    end
  end
end
