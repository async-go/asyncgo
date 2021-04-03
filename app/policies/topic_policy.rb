# frozen_string_literal: true

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

  def edit?
    user &&
      record.team == user.team &&
      record.active?
  end

  def create?
    user &&
      record.team == user.team
  end

  def update?
    user &&
      record.team == user.team
  end

  def subscribe?
    user &&
      record.team == user.team
  end

  def toggle?
    user &&
      record.team == user.team
  end
end
