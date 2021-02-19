# frozen_string_literal: true

module Users
  class PreferencesController < ::Users::ApplicationController
    include Pundit

    def update
      @preference = user.preference
      authorize(@preference, policy_class: Users::PreferencePolicy)

      if @preference.update(preference_params)
        redirect_to edit_user_path(@preference.user),
                    flash: { success: 'User preferences were successfully updated.' }
      else
        render 'users/edit'
      end
    end

    private

    def preference_params
      params.require(:user_preference).permit(:digest_enabled)
    end
  end
end