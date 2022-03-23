# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Teams', type: :system do
  include SignInOutSystemHelpers

  it 'allows the user to create a team' do
    visit '/'
    sign_in_user

    fill_in 'team[name]', with: 'Team name'
    click_button 'Create Team'

    expect(page).to have_text('Team name')
  end

  it 'allows the user to invite users to the team' do
    visit '/'
    sign_in_user(create(:user, :team))
    click_link 'Admin'

    fill_in 'user[email]', with: 'test@example.com'
    click_button 'Invite User'

    expect(page).to have_link('test@example.com')
  end

  it 'allows the user to remove users from the team' do
    user = create(:user, :team)
    other_user = create(:user, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Admin'

    accept_alert do
      click_link other_user.email
    end

    expect(page).not_to have_link(other_user.email)
  end

  it 'allows the user to change the name' do
    user = create(:user, :team)

    visit '/'
    sign_in_user(user)
    click_link 'Admin'

    fill_in 'team[name]', with: 'New team name'
    click_button 'Save Name'

    expect(page).to have_text('New team name')
  end

  it 'allows the user to set a message' do
    user = create(:user, :team)

    visit '/'
    sign_in_user(user)
    click_link 'Admin'

    fill_in 'team[message]', with: 'New team message'
    click_button 'Save Message'

    click_link 'Topics'

    expect(page).to have_text('New team message')
  end

  it 'allows the user to clear the message' do
    team = create(:team, message: 'hello world')
    user = create(:user, team:)

    visit '/'
    sign_in_user(user)
    click_link 'Admin'

    fill_in 'team[message]', with: ''
    click_button 'Save Message'

    click_link 'Topics'

    expect(page).not_to have_text('hello world')
  end

  it 'allows the user to send a support email' do
    visit '/'
    sign_in_user(create(:user, :team))
    click_link 'Admin'

    fill_in 'body', with: 'Hello world'
    click_button 'Send Email'

    expect(page).to have_text('Support request was successfully sent.')
  end

  it 'shows the buy subscription button for unsubscribed teams' do
    visit '/'
    sign_in_user(create(:user, :team))
    click_link 'Admin'

    expect(page).to have_button('Buy Subscription')
  end

  it 'shows the manage subscription link for subscribed teams' do
    user = create(:user, :team)
    user.team.create_subscription!(active: true)

    visit '/'
    sign_in_user(user)
    click_link 'Admin'

    expect(page).to have_link('Manage Subscription')
  end

  it 'disallows creating team names with a :' do
    visit '/'
    sign_in_user

    fill_in 'team[name]', with: 'Team name :'
    click_button 'Create Team'

    expect(page).not_to have_text('Team name :')
  end

  it 'disallows creating team names with a /' do
    visit '/'
    sign_in_user

    fill_in 'team[name]', with: 'Team name /'
    click_button 'Create Team'

    expect(page).not_to have_text('Team name /')
  end

  it 'disallows creating team names with a \\' do
    visit '/'
    sign_in_user

    fill_in 'team[name]', with: 'Team name \\'
    click_button 'Create Team'

    expect(page).not_to have_text('Team name \\')
  end

  it 'disallows the user to change the name to a name with a :' do
    user = create(:user, :team)

    visit '/'
    sign_in_user(user)
    click_link 'Admin'

    fill_in 'team[name]', with: 'New team name :'
    click_button 'Save Name'

    expect(page).not_to have_text('New team name :')
  end

  it 'disallows the user to change the name to a name with a /' do
    user = create(:user, :team)

    visit '/'
    sign_in_user(user)
    click_link 'Admin'

    fill_in 'team[name]', with: 'New team name /'
    click_button 'Save Name'

    expect(page).not_to have_text('New team name /')
  end

  it 'disallows the user to change the name to a name with a \\' do
    user = create(:user, :team)

    visit '/'
    sign_in_user(user)
    click_link 'Admin'

    fill_in 'team[name]', with: 'New team name \\'
    click_button 'Save Name'

    expect(page).not_to have_text('New team name \\')
  end
end
