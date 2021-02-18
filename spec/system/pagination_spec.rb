# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Pagination', type: :system do
  include SignInOutSystemHelpers

  it 'paginates active topics' do
    user = FactoryBot.create(:user, :team)
    topics = FactoryBot.create_list(:topic, 25, user: user, team: user.team)

    visit '/'
    sign_in_user(user)

    click_link 'Topics'

    expect(page).not_to have_text(topics.last.title)
    click_link '2'
    expect(page).to have_text(topics.last.title)
  end

  it 'paginates closed topics' do
    user = FactoryBot.create(:user, :team)
    topics = FactoryBot.create_list(:topic, 25, user: user, team: user.team, status: :closed)

    visit '/'
    sign_in_user(user)

    click_link 'Topics'

    expect(page).not_to have_text(topics.last.title)
    click_link '2'
    expect(page).to have_text(topics.last.title)
  end

  it 'paginates topic comments' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, user: user, team: user.team)
    comments = FactoryBot.create_list(:comment, 25, topic: topic, user: user)

    visit '/'
    sign_in_user(user)

    click_link 'Topics'
    click_link topic.title

    expect(page).not_to have_text(comments.last.body)
    click_link 'Next'
    expect(page).to have_text(comments.last.body)
  end

  it 'paginates notifications' do
    user = FactoryBot.create(:user, :team)
    FactoryBot.create_list(:notification, 20, user: user, action: :updated)
    notification = FactoryBot.create(:notification, user: user, action: :created)

    visit '/'
    sign_in_user(user)

    click_link '21'

    expect(page).not_to have_text(notification.action)
    click_link 'Next'
    expect(page).to have_text(notification.action)
  end

  it 'paginates user members' do
    user = FactoryBot.create(:user, :team)
    team_members = FactoryBot.create_list(:user, 25, team: user.team)

    visit '/'
    sign_in_user(user)

    click_link 'Admin'

    expect(page).not_to have_text(team_members.last.email)
    click_link 'Next'
    expect(page).to have_text(team_members.last.email)
  end
end
