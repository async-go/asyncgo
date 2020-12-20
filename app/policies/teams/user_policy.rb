# frozen_string_literal: true

module Teams
  class UserPolicy < ApplicationPolicy
    def create?
      user &&
        record == user.team
    end

    def destroy?
      user &&
        record == user.team
    end
  end
end
