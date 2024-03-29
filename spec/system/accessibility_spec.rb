# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Accessibility', type: :system do
  include SignInOutSystemHelpers

  it 'makes sure homepage is accessible' do
    visit '/'

    expect(page).to be_axe_clean.skipping('color-contrast')
  end

  it 'makes sure new topic is accessible' do
    team = create(:team)
    user = create(:user, team:)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link 'New Topic'

    expect(page).to have_button 'Create'
    expect(page).to be_axe_clean.skipping('button-name')
  end
end
