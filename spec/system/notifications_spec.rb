# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Notifications', type: :system do
  include SignInOutSystemHelpers

  it 'allows user to read a notification' do
    user = FactoryBot.create(:user, :team)
    actor = FactoryBot.create(:user, name: 'John Doe', team: user.team)
    topic = FactoryBot.create(:topic, user: user, team: user.team)
    FactoryBot.create(:notification, user: user, actor: actor, target: topic)

    visit '/'
    sign_in_user(user)

    expect(page).to have_text('🔔 1')
    find('.dropdown-toggle.badge').click
    click_link 'John Doe updated an topic'
    expect(page).to have_text('🔔 0')
    expect(page).to have_text(topic.title)
  end

  it 'creates notifications when other user comments on subscribed topic' do
    user = FactoryBot.create(:user, :team)
    actor = FactoryBot.create(:user, name: 'John Doe', team: user.team)

    visit '/'
    sign_in_user(user)
    expect(page).to have_text('🔔 0')
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
    click_button 'Add Comment'

    click_link 'Sign out'
    sign_in_user(user)
    expect(page).to have_text('🔔 1')
  end
end
