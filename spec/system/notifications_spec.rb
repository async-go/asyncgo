# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Notifications', type: :system do
  include SignInOutSystemHelpers, TuiEditorSystemHelpers

  it 'allows user to read a notification' do
    user = FactoryBot.create(:user, :team)
    notification = FactoryBot.create(:notification, user: user)

    visit '/'

    sign_in_user(user)
    click_link 'Has notification 1'
    expect(page).to have_link('Has notification 1')

    click_link "#{notification.actor.printable_name} updated the topic #{notification.target.title}"
    expect(page).to have_link('Has notification 0')
    expect(page).to have_text(notification.target.title)
  end

  it 'creates a notification when someone in team creates a topic' do
    user = FactoryBot.create(:user, :team)
    actor = FactoryBot.create(:user, team: user.team)

    visit '/'

    sign_in_user(actor)
    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    expect(page).to have_selector('#editor_description')
    tuieditor_setcontent('editor_description', 'Sample topic description')
    click_button 'Create'
    click_link 'Sign out'

    sign_in_user(user)
    expect(page).to have_link('Has notification 1')
  end

  it 'creates a notification when a watched topic is resolved' do
    user = FactoryBot.create(:user, :team)
    actor = FactoryBot.create(:user, team: user.team)

    visit '/'

    sign_in_user(user)
    expect(page).to have_link('Has notification 0')

    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    expect(page).to have_selector('#editor_description')
    tuieditor_setcontent('editor_description', 'Sample topic description')
    click_button 'Create'
    click_link 'Sign out'

    sign_in_user(actor)
    click_link 'Topics'
    click_link 'Sample topic'
    click_button 'Resolve'
    click_link 'Sign out'

    sign_in_user(user)
    expect(page).to have_link('Has notification 1')
  end

  it 'creates a notification when a watched topic is reopened' do
    user = FactoryBot.create(:user, :team)
    actor = FactoryBot.create(:user, team: user.team)

    visit '/'
    sign_in_user(user)
    expect(page).to have_link('Has notification 0')

    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    expect(page).to have_selector('#editor_description')
    tuieditor_setcontent('editor_description', 'Sample topic description')
    click_button 'Create'
    click_link 'Sign out'

    sign_in_user(actor)
    click_link 'Topics'
    click_link 'Sample topic'
    click_button 'Resolve'
    click_button 'Reopen'
    click_link 'Sign out'

    sign_in_user(user)
    expect(page).to have_link('Has notification 2')
  end

  it 'creates a notification when other user comments on subscribed topic' do
    user = FactoryBot.create(:user, :team)
    actor = FactoryBot.create(:user, team: user.team)

    visit '/'
    sign_in_user(user)
    expect(page).to have_link('Has notification 0')

    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    expect(page).to have_selector('#editor_description')
    tuieditor_setcontent('editor_description', 'Sample topic description')
    click_button 'Create'
    click_link 'Sign out'

    sign_in_user(actor)
    click_link 'Topics'
    click_link 'Sample topic'
    expect(page).to have_selector('#editor_comment_new')
    tuieditor_setcontent('editor_comment_new', '__Sample content__')
    click_button 'Add Comment'
    click_link 'Sign out'

    sign_in_user(user)
    expect(page).to have_link('Has notification 1')
  end

  it 'creates a notification when user gets mentioned' do
    user = FactoryBot.create(:user, :team)
    actor = FactoryBot.create(:user, team: user.team)

    visit '/'
    sign_in_user(actor)

    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    expect(page).to have_selector('#editor_description')
    tuieditor_setcontent('editor_description', "This is a test mention for @#{user.email}")
    click_button 'Create'
    click_link 'Sign out'

    sign_in_user(user)
    expect(page).to have_link('Has notification 2')
  end

  it 'creates a notification when user gets mentioned inside link' do
    user = FactoryBot.create(:user, :team)
    actor = FactoryBot.create(:user, team: user.team)

    visit '/'
    sign_in_user(actor)

    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    expect(page).to have_selector('#editor_description')
    tuieditor_setcontent('editor_description', "This is a test mention for @[#{user.email}](mailto:#{user.email})")
    click_button 'Create'
    click_link 'Sign out'

    sign_in_user(user)
    expect(page).to have_link('Has notification 2')
  end

  it 'clears topic and comment notifications when you visit a topic' do
    user = FactoryBot.create(:user, :team)
    actor = FactoryBot.create(:user, team: user.team)

    visit '/'
    sign_in_user(actor)

    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    expect(page).to have_selector('#editor_description')
    tuieditor_setcontent('editor_description', 'Sample topic description')
    click_button 'Create'
    click_link 'Sign out'

    sign_in_user(user)
    expect(page).to have_link('Has notification 1')

    click_link 'Topics'
    click_link 'Sample topic'
    expect(page).to have_link('Has notification 0')

    click_button 'topic-watch'
    click_link 'Sign out'

    sign_in_user(actor)
    click_link 'Topics'
    click_link 'Sample topic'
    expect(page).to have_selector('#editor_comment_new')
    tuieditor_setcontent('editor_comment_new', '__Sample content__')
    click_button 'Add Comment'
    click_link 'Sign out'

    sign_in_user(user)
    expect(page).to have_link('Has notification 1')

    click_link 'Sample topic'
    expect(page).to have_link('Has notification 0')
  end

  it 'allows user to clear all notifications' do
    user = FactoryBot.create(:user, :team)
    FactoryBot.create(:notification, user: user)

    visit '/'

    sign_in_user(user)
    click_link 'Has notification 1'
    expect(page).to have_link('Has notification 1')

    click_link 'Clear all notifications (all pages)'
    expect(page).to have_link('Has notification 0')
  end
end
