# frozen_string_literal: true

module Users
  class PreferencesController < ::Users::ApplicationController
    def update
      @preference = user.preference
      authorize(@preference, policy_class: Users::PreferencePolicy)

      if @preference.update(preference_params)
        redirect_to edit_user_path(@preference.user),
                    flash: { success: 'User preferences were successfully updated.' }
      else
        render 'users/edit', status: :unprocessable_entity
      end
    end

    private

    def preference_params
      params.require(:user_preference).permit(:digest_enabled, :fluid_layout, :inverse_comment_order)
    end
  end
end
