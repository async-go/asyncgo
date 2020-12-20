# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Teams', type: :system do
  include SignInOutSystemHelpers

  it 'allows the user to create a team' do
    visit '/'
    sign_in_user

    click_link 'Create Team'

    fill_in 'team[name]', with: 'Team name'
    click_button 'Submit'

    expect(page).to have_text('Team name')
  end

  it 'allows the user to add other users to the team' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)
    team.users << user
    visit '/'
    sign_in_user(user)
    click_link 'Team'

    select other_user.email, from: 'add-user'
    click_button 'Add User'

    expect(page).to have_link("Remove #{user.email}")
  end

  it 'allows the user to remove users from the team' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)
    team.users << user
    team.users << other_user
    visit '/'
    sign_in_user(user)
    click_link 'Team'

    click_link "Remove #{other_user.email}"

    expect(page).to have_select('add-user', with_options: [other_user.email])
  end
end
