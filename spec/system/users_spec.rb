# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Users', type: :system do
  include SignInOutSystemHelpers

  it 'allows the user to change digest preferences' do
    visit '/'
    sign_in_user

    click_link 'Profile'

    expect(page).to have_text('Currently subscribed: Yes')
    click_button 'Toggle notification status'
    expect(page).to have_text('Currently subscribed: No')
    click_button 'Toggle notification status'
    expect(page).to have_text('Currently subscribed: Yes')
  end
end
