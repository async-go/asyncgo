# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Notifications', type: :system do
  include SignInOutSystemHelpers

  it 'allows user to read a notification' do
    user = create(:user, :team)
    notification = create(:notification, user:)

    visit '/'

    sign_in_user(user)
    click_link 'Has notification 1'
    expect(page).to have_link('Has notification 1')

    click_link "#{notification.actor.printable_name} updated the topic #{notification.target.title}"
    expect(page).to have_link('Has notification 0')
    expect(page).to have_text(notification.target.title)
  end

  it 'creates a notification when someone in team creates a topic' do
    user = create(:user, :team)
    actor = create(:user, team: user.team)

    visit '/'

    sign_in_user(actor)
    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    within('[data-target="topic_description"]') do
      find('.tui-editor-contents').set('Sample topic description')
    end
    click_button 'Create'
    click_link 'Sign out'

    sign_in_user(user)
    expect(page).to have_link('Has notification 1')
  end

  it 'creates a notification when a watched topic is resolved' do
    user = create(:user, :team)
    actor = create(:user, team: user.team)

    visit '/'

    sign_in_user(user)
    expect(page).to have_link('Has notification 0')

    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    within('[data-target="topic_description"]') do
      find('.tui-editor-contents').set('Sample topic description')
    end
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
    user = create(:user, :team)
    actor = create(:user, team: user.team)

    visit '/'
    sign_in_user(user)
    expect(page).to have_link('Has notification 0')

    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    within('[data-target="topic_description"]') do
      find('.tui-editor-contents').set('Sample topic description')
    end
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
    user = create(:user, :team)
    actor = create(:user, team: user.team)

    visit '/'
    sign_in_user(user)
    expect(page).to have_link('Has notification 0')

    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    within('[data-target="topic_description"]') do
      find('.tui-editor-contents').set('Sample topic description')
    end
    click_button 'Create'
    click_link 'Sign out'

    sign_in_user(actor)
    click_link 'Topics'
    click_link 'Sample topic'

    within('[data-target="comment_body"]') do
      find('.tui-editor-contents').set('Sample content')
    end
    click_button 'Add Comment'
    click_link 'Sign out'

    sign_in_user(user)
    expect(page).to have_link('Has notification 1')
  end

  it 'creates a notification when user gets mentioned' do
    user = create(:user, :team)
    actor = create(:user, team: user.team)

    visit '/'
    sign_in_user(actor)

    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    within('[data-target="topic_description"]') do
      find('.tui-editor-contents').set("This is a test mention for @#{user.email}")
    end
    click_button 'Create'
    click_link 'Sign out'

    sign_in_user(user)
    expect(page).to have_link('Has notification 2')
  end

  it 'clears topic and comment notifications when you visit a topic' do
    user = create(:user, :team)
    actor = create(:user, team: user.team)

    visit '/'
    sign_in_user(actor)

    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    within('[data-target="topic_description"]') do
      find('.tui-editor-contents').set('Sample topic description')
    end
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
    within('[data-target="comment_body"]') do
      find('.tui-editor-contents').set('Sample comment body')
    end
    click_button 'Add Comment'
    click_link 'Sign out'

    sign_in_user(user)
    expect(page).to have_link('Has notification 1')

    click_link 'Sample topic'
    expect(page).to have_link('Has notification 0')
  end

  it 'allows user to clear all notifications' do
    user = create(:user, :team)
    create(:notification, user:)

    visit '/'

    sign_in_user(user)
    click_link 'Has notification 1'
    expect(page).to have_link('Has notification 1')

    click_link 'Clear all notifications (all pages)'
    expect(page).to have_link('Has notification 0')
  end
end
