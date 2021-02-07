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

  it 'allows the user to create a topic using markdown' do
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

  it 'allows the user to edit a topic' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    topic = FactoryBot.create(:topic, team: team)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit Topic Context'

    fill_in 'topic[description]', with: 'This is an update'
    click_button 'Update Topic'

    expect(page).to have_text('This is an update')
  end

  it 'allows the user to summarize a outcome on the topic using markdown' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    topic = FactoryBot.create(:topic, team: team)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit Topic Context'

    fill_in 'topic[outcome]', with: '__Sample outcome__'
    click_button 'Update Topic'

    expect(page.body).to include('<strong>Sample outcome</strong>')
  end

  it 'allows the user to leave comments on the topic using markdown' do
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

    find(:fillable_field, 'comment[body]').send_keys('This is updated content')
    click_button 'Update Comment'

    expect(page).to have_text('This is updated content')
  end

  it 'allows the user to close and open the topic' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    topic = FactoryBot.create(:topic, team: team)
    FactoryBot.create(:comment, topic: topic, user: user)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_button 'Resolve Topic'
    click_button 'Reopen Topic'

    expect(page).to have_button('Resolve Topic')
  end

  it 'allows the user to subscribe and unsubscribe from the topic' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    topic = FactoryBot.create(:topic, team: team)
    FactoryBot.create(:comment, topic: topic, user: user)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title

    expect(page).to have_button('Watch Topic')
    click_button 'Watch Topic'
    expect(page).to have_button('Unwatch Topic')
    click_button 'Unwatch Topic'
    expect(page).to have_button('Watch Topic')
  end
end
