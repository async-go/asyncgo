# frozen_string_literal: true

module Teams
  class UserPolicy < ApplicationPolicy
    def create?
      user &&
        record == user.team
    end

    def destroy?
      user &&
        record.team == user.team &&
        record != user
    end

    def toggle_digests?
      user &&
        record.team == user.team
    end
  end
end
