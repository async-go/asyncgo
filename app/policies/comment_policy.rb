# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
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