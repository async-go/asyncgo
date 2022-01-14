# frozen_string_literal: true

class TopicPolicy < ApplicationPolicy
  def index?
    user &&
      record == user.team
  end

  def show?
    user &&
      record.team == user.team &&
      record.is_archived == false
  end

  def new?
    user &&
      record.team == user.team
  end

  def edit?
    user &&
      record.team == user.team &&
      record.is_archived == false
  end

  def create?
    user &&
      record.team == user.team
  end

  def update?
    user &&
      record.team == user.team &&
      record.is_archived == false
  end

  def toggle?
    user &&
      record.team == user.team &&
      record.is_archived == false
  end

  def subscribe?
    user &&
      record.team == user.team &&
      record.is_archived == false
  end

  def pin?
    user &&
      record.team == user.team &&
      record.is_archived == false
  end

  def archive?
    user &&
      record.team == user.team &&
      record.is_archived == false
  end
end
