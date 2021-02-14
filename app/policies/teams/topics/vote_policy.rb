# frozen_string_literal: true

module Teams
  module Topics
    class VotePolicy < ApplicationPolicy
      def create?
        user &&
          record.team == user.team
      end

      def destroy?
        user &&
          record.user == user
      end
    end
  end
end
