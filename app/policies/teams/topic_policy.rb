# frozen_string_literal: true

module Teams
  class TopicPolicy < ApplicationPolicy
    def index?
      user &&
        record == user.team
    end

    def show?
      user &&
        record.team == user.team
    end

    def new?
      user &&
        record.team == user.team
    end

    def create?
      user &&
        record.team == user.team
    end
  end
end
