# frozen_string_literal: true

module Teams
  class UserPolicy < ApplicationPolicy
    def index?
      user &&
        record == user.team
    end

    def create?
      user &&
        record == user.team
    end

    def destroy?
      user &&
        record.team == user.team
    end
  end
end
