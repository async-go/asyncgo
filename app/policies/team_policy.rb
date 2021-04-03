# frozen_string_literal: true

class TeamPolicy < ApplicationPolicy
  def edit?
    user &&
      record == user.team
  end

  def new?
    user
  end

  def create?
    user
  end

  def update?
    user &&
      record == user.team
  end

  def support?
    user &&
      record == user.team
  end
end
