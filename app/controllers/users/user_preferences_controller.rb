# frozen_string_literal: true

module Users
  class UserPreferencesController < ::Users::ApplicationController
    include Pundit

    def update
      @user_preference = user.user_preference
      authorize([:users, @user_preference])

      if @user_preference.update(user_preference_params)
        redirect_to edit_user_path(@user_preference.user),
                    flash: { success: 'User preferences were successfully updated.' }
      else
        render 'users/edit'
      end
    end

    private

    def user_preference_params
      params.require(:user_preference).permit(:digest_enabled)
    end
  end
end
