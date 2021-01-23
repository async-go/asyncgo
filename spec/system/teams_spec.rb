# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Teams', type: :system do
  include SignInOutSystemHelpers

  it 'allows the user to create a team' do
    visit '/'
    sign_in_user

    click_link 'Create Team'

    fill_in 'team[name]', with: 'Team name'
    click_button 'Create Team'

    expect(page).to have_text('Team name')
  end

  it 'allows the user to invite users to the team' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    team.users << user
    visit '/'
    sign_in_user(user)
    click_link 'Admin'

    fill_in 'user[email]', with: 'test@example.com'
    click_button 'Invite User'

    expect(page).to have_link('test@example.com')
  end

  it 'allows the user to remove users from the team' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)
    team.users << user
    team.users << other_user
    visit '/'
    sign_in_user(user)
    click_link 'Admin'

    click_link other_user.email

    expect(page).not_to have_link(other_user.email)
  end

  it 'allows the user to send a support email' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)
    team.users << user
    team.users << other_user
    visit '/'
    sign_in_user(user)
    click_link 'Admin'

    fill_in 'body', with: 'Hello world'
    click_button 'Send Email'

    expect(page).to have_text('Support request was successfully sent.')
  end
end
