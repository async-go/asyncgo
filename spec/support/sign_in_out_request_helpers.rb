# frozen_string_literal: true

module SignInOutRequestHelpers
  def sign_in(user)
    OmniAuth.config.add_mock(:google_oauth2,
                             info: { email: user.email })
    post '/auth/google_oauth2'
    # This is a redirect to the callback controller
    follow_redirect!
    # This is a redirect back to the referrer path
    follow_redirect!
  end

  def sign_out
    delete '/sign_out'
    follow_redirect!
  end
end
