# frozen_string_literal: true

class UsersController < ::Users::ApplicationController
  def edit
    @user = user
    authorize(@user)
  end
end
