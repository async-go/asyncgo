# frozen_string_literal: true

module SignInOutSystemHelpers
  def sign_in_user(user = nil)
    (user || FactoryBot.create(:user)).tap do |active_user|
      OmniAuth.config.add_mock(:google_oauth2,
                               info: { email: active_user.email })
      click_link('Sign in', class: 'nav-link')
    end
  end
end
