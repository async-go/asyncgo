# frozen_string_literal: true

module Users
  class PreferencePolicy < ApplicationPolicy
    def update?
      user &&
        record.user == user
    end
  end
end
