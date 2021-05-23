# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Authentication', type: :system do
  include SignInOutSystemHelpers

  it 'allows user creation' do
    visit '/'

    OmniAuth.config.add_mock(:google_oauth2,
                             info: { email: 'test@example.com',
                                     name: 'Test Person' })
    click_button('Google')
    expect(page).to have_link('Sign out')
  end

  it 'allows signing out' do
    visit '/'

    sign_in_user

    expect(page).to have_link('Sign out')
  end
end
