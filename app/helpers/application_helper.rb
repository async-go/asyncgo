# frozen_string_literal: true

module ApplicationHelper
  def printable_name(user)
    if user.name?
      user.name
    else
      user.email
    end
  end
end
