# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def edit?
    user == record
  end
end
