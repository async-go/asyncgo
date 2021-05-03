# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Pagination', type: :system do
  include SignInOutSystemHelpers

  it 'paginates active topics' do
    user = FactoryBot.create(:user, :team)
    FactoryBot.create_list(
      :topic, 20, user: user, team: user.team, status: :active,
                  due_date: Date.new(2020, 1, 1)
    )
    FactoryBot.create(
      :topic, user: user, team: user.team, status: :active,
              due_date: Date.new(2021, 1, 1), title: 'thisisthelasttopic'
    )

    visit '/'
    sign_in_user(user)

    click_link 'Topics'

    expect(page).not_to have_text('thisisthelasttopic')
    click_link '2'
    expect(page).to have_text('thisisthelasttopic')
  end

  it 'paginates resolved topics' do
    user = FactoryBot.create(:user, :team)
    FactoryBot.create_list(
      :topic, 20, user: user, team: user.team, status: :resolved,
                  updated_at: Date.new(2021, 1, 1)
    )
    FactoryBot.create(
      :topic, user: user, team: user.team, status: :resolved,
              updated_at: Date.new(2020, 1, 1), title: 'thisisthelasttopic'
    )

    visit '/'
    sign_in_user(user)

    click_link 'Topics'

    expect(page).not_to have_text('thisisthelasttopic')
    click_link '2'
    expect(page).to have_text('thisisthelasttopic')
  end

  it 'paginates topic comments' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, user: user, team: user.team)
    FactoryBot.create_list(
      :comment, 20, topic: topic, user: user, created_at: Date.new(2020, 1, 1)
    )
    FactoryBot.create(
      :comment, topic: topic, user: user, content: 'thisisthelastcomment',
                created_at: Date.new(2021, 1, 1)
    )

    visit '/'
    sign_in_user(user)

    click_link 'Topics'
    click_link topic.title

    expect(page).not_to have_text('thisisthelastcomment')
    click_link 'Next'
    expect(page).to have_text('thisisthelastcomment')
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
    FactoryBot.create_list(
      :user, 20, team: user.team, created_at: Date.new(2020, 1, 1)
    )
    FactoryBot.create(
      :user, team: user.team, email: 'thisisthelastuser@example.com',
             created_at: Date.new(2021, 1, 1)
    )

    visit '/'
    sign_in_user(user)

    click_link 'Admin'

    expect(page).not_to have_text('thisisthelastuser@example.com')
    click_link 'Next'
    expect(page).to have_text('thisisthelastuser@example.com')
  end
end
