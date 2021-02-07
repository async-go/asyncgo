# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Accessibility', type: :system do
  include SignInOutSystemHelpers

  it 'makes sure homepage is accessible' do
    visit '/'

    expect(page).to be_axe_clean
  end

  it 'makes sure new topic is accessible' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user, team: team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link 'New Topic'

    expect(page).to have_text 'New Topic'
    expect(page).to be_axe_clean
  end
end
