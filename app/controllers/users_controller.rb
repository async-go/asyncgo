# frozen_string_literal: true

class UsersController < ::Users::ApplicationController
  include Pundit

  def edit
    @user = user
    authorize(@user)
  end
end
