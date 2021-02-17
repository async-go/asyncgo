# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Notifications', type: :system do
  include SignInOutSystemHelpers

  it 'allows user to read a notification' do
    user = FactoryBot.create(:user, :team)
    notification = FactoryBot.create(:notification, user: user)

    visit "/users/#{user.id}/notifications"
    sign_in_user(user)

    expect(find('#notificationCount')).to have_text('1')
    click_link "#{notification.actor.printable_name} updated the topic #{notification.target.title}"
    expect(find('#notificationCount')).to have_text('0')
    expect(page).to have_text(notification.target.title)
  end

  it 'creates notifications when other user comments on subscribed topic' do
    user = FactoryBot.create(:user, :team)
    actor = FactoryBot.create(:user, name: 'John Doe', team: user.team)

    visit '/'
    sign_in_user(user)
    expect(find('#notificationCount')).to have_text('0')
    click_link 'Topics'
    click_link 'New Topic'
    fill_in 'topic[title]', with: 'Sample topic'
    fill_in 'topic[description]', with: 'Sample topic description'
    click_button 'Create Topic'

    click_link 'Sign out'
    sign_in_user(actor)

    click_link 'Topics'
    click_link 'Sample topic'

    fill_in 'comment[body]', with: '__Sample content__'
    click_button 'Create Comment'

    click_link 'Sign out'
    sign_in_user(user)
    expect(find('#notificationCount')).to have_text('1')
  end

  it 'allows user to clear all notifications' do
    user = FactoryBot.create(:user, :team)
    FactoryBot.create(:notification, user: user)
    visit "/users/#{user.id}/notifications"
    sign_in_user(user)

    expect(find('#notificationCount')).to have_text('1')
    click_link 'Clear all notifications (all pages)'
    expect(find('#notificationCount')).to have_text('0')
  end
end
