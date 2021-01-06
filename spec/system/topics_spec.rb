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
    click_button 'Create Topic'

    expect(page).to have_text('Sample title')
  end

  it 'allows the user to edit a topic' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    topic = FactoryBot.create(:topic, team: team)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit Topic'

    fill_in 'topic[description]', with: 'This is an update'
    click_button 'Update Topic'

    expect(page).to have_text('This is an update')
  end

  it 'allows the user to leave comments on the topic' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    topic = FactoryBot.create(:topic, team: team)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title

    fill_in 'comment[body]', with: 'Sample content'
    click_button 'Create Comment'

    expect(page).to have_text('Sample content')
  end

  it 'allows the user to update a comment on the topic' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    topic = FactoryBot.create(:topic, team: team)
    FactoryBot.create(:comment, topic: topic, user: user)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit Comment'

    fill_in 'comment[body]', with: 'Updated content'
    click_button 'Update Comment'

    expect(page).to have_text('Updated content')
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
    click_link 'Edit Decision'

    fill_in 'topic[decision]', with: 'Sample decision'
    click_button 'Update Topic'

    expect(page).to have_text('Sample decision')
  end

  it 'allows using markdown for topic description' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link 'New Topic'

    fill_in 'topic[title]', with: 'Sample title'
    fill_in 'topic[description]', with: '__Sample topic content__'
    click_button 'Create Topic'

    expect(page).to have_text('Sample title')
    expect(page.body).to include('<strong>Sample topic content</strong>')
  end

  it 'allows using markdown for comment body' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    topic = FactoryBot.create(:topic, team: team)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title

    fill_in 'comment[body]', with: '__Sample content__'
    click_button 'Create Comment'

    expect(page.body).to include('<strong>Sample content</strong>')
  end
end
