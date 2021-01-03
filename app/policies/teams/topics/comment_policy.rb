# frozen_string_literal: true

module Teams
  module Topics
    class CommentPolicy < ApplicationPolicy
      def new?
        user &&
          record.topic.team == user.team
      end

      def edit?
        user &&
          record.user == user
      end

      def create?
        user &&
          record.topic.team == user.team
      end

      def update?
        user &&
          record.user == user
      end
    end
  end
end
