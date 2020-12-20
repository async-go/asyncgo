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
end
