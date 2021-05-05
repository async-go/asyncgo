# frozen_string_literal: true

class ExtensionPolicy < ApplicationPolicy
  def new_topic?
    user&.team
  end
end
