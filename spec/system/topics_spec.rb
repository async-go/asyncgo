# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Topics', type: :system do
  include SignInOutSystemHelpers

  it 'shows all topics' do
    team = FactoryBot.create(:team)
    topics = FactoryBot.create_list(:topic, 2, team: team)
    user = FactoryBot.create(:user)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'

    topics.each do |topic|
      expect(page).to have_link(topic.title)
    end
  end

  it 'allows the user to create a topic' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link 'New Topic'

    fill_in 'topic[title]', with: 'Sample title'
    fill_in 'topic[description]', with: 'Sample topic content'
    click_button 'Submit'

    expect(page).to have_text('Sample title')
  end

  it 'allows the user to leave comments on topic' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    topic = FactoryBot.create(:topic, team: team)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'New Comment'

    fill_in 'comment[body]', with: 'Sample content'
    click_button 'Submit'

    expect(page).to have_text('Sample content')
  end

  it 'allows the user to summarize a decision on the topic' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    topic = FactoryBot.create(:topic, team: team)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title

    fill_in 'topic[decision]', with: 'Sample decision'
    click_button 'Submit'

    expect(page).to have_text('Sample decision')
  end
end
