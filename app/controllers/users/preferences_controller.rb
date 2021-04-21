# frozen_string_literal: true

module Users
  class PreferencesController < ::Users::ApplicationController
    def update
      @preferences = user.preferences
      authorize(@preferences, policy_class: Users::PreferencesPolicy)

      if @preferences.update(preferences_params)
        redirect_to edit_user_path(@preferences.user),
                    flash: { success: 'User preferences were successfully updated.' }
      else
        render 'users/edit', status: :unprocessable_entity
      end
    end

    private

    def preferences_params
      params.require(:user_preferences).permit(:digest_enabled, :fluid_layout, :inverse_comment_order)
    end
  end
end
