# frozen_string_literal: true

module Teams
  module Topics
    module Comments
      class VotePolicy < ApplicationPolicy
        def create?
          user &&
            record.topic.team == user.team
        end

        def destroy?
          user &&
            record.user == user
        end
      end
    end
  end
end
