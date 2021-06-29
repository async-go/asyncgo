# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def new?
    user &&
      record.topic.team == user.team
  end

  def edit?
    user &&
      record.user == user &&
      record.is_archived == false
  end

  def create?
    user &&
      record.topic.team == user.team
  end

  def update?
    user &&
      record.user == user &&
      record.is_archived == false
  end

  def archive?
    user &&
      record.user == user &&
      record.is_archived == false
  end
end
