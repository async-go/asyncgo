# frozen_string_literal: true

module Teams
  module Topics
    class CommentPolicy < ApplicationPolicy
      def new?
        user &&
          record.topic.team == user.team
      end

      def create?
        user &&
          record.topic.team == user.team
      end
    end
  end
end
