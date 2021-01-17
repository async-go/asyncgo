# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Authentication', type: :system do
  include SignInOutSystemHelpers

  it 'allows user creation' do
    visit '/'

    OmniAuth.config.add_mock(:google_oauth2,
                             info: { email: 'test@example.com' })
    click_button('Sign in', class: 'nav-link')
    expect(page).to have_link('Sign out')
  end

  it 'allows signing out' do
    visit '/'

    sign_in_user

    click_link('Sign out')
    expect(page).to have_button('Sign in')
  end
end
