# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Topics', type: :system do
  include SignInOutSystemHelpers

  it 'shows all topics' do
    user = FactoryBot.create(:user, :team)
    topics = FactoryBot.create_list(:topic, 2, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'

    topics.each do |topic|
      expect(page).to have_link(topic.title)
    end
  end

  it 'allows the user to create a topic using markdown' do
    visit '/'
    sign_in_user(FactoryBot.create(:user, :team))
    click_link 'Topics'
    click_link 'New Topic'

    fill_in 'topic[title]', with: 'Sample title'
    fill_in 'topic[description]', with: '__Sample topic content__'
    click_button 'Create'

    expect(page).to have_text('Sample title')
    expect(page).to have_selector('strong', text: 'Sample topic content')
  end

  it 'allows the user to edit a topic' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit'

    fill_in 'topic[description]', with: 'This is an update'
    click_button 'Update'

    expect(page).to have_text('This is an update')
  end

  it 'prevents overwriting topic updates for description' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit'

    update_topic_path = team_topic_path(topic.team, topic)
    expect(page).to have_selector("form[action='#{update_topic_path}']")
    fill_in 'topic[description]', with: 'This is an update'
    topic.update!(description: 'This is an external update',
                  description_html: '<p>This is an external update',
                  description_checksum: Digest::MD5.hexdigest(topic.description))
    click_button 'Update'

    expect(page).to have_text(Topic::CHECKSUM_ERROR_MESSAGE)
  end

  it 'prevents overwriting topic updates for outcome' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit'

    update_topic_path = team_topic_path(topic.team, topic)
    expect(page).to have_selector("form[action='#{update_topic_path}']")
    fill_in 'topic[outcome]', with: 'This is an update'
    topic.update!(outcome: 'This is an external update',
                  outcome_html: '<p>This is an external update</p>',
                  outcome_checksum: Digest::MD5.hexdigest(''))
    click_button 'Update'

    expect(page).to have_text(Topic::CHECKSUM_ERROR_MESSAGE)
  end

  it 'allows the user to summarize an outcome using markdown' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit'

    fill_in 'topic[outcome]', with: '__Sample outcome__'
    click_button 'Update'

    expect(page).to have_selector('strong', text: 'Sample outcome')
  end

  it 'allows the user to close and open the topic' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_button 'Resolve'
    click_button 'Reopen'

    expect(page).to have_button('Resolve')
  end

  it 'allows the user to pin and unpin the topic' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_button 'Pin'
    click_button 'Unpin'

    expect(page).to have_button('Pin')
  end

  it 'allows the user to subscribe and unsubscribe from the topic' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title

    expect(page).to have_button('Watch')
    click_button 'Watch'
    expect(page).to have_button('Unwatch')
    click_button 'Unwatch'
    expect(page).to have_button('Watch')
  end

  it 'allows the user to vote on a topic' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title

    emoji = Emoji.find_by_alias('thumbsup').raw # rubocop:disable Rails/DynamicFindBy
    expect(page).to have_selector("input[type=submit][value='#{emoji} 0']")
    find("input[type=submit][value='#{emoji} 0']").click
    expect(page).to have_selector("input[type=submit][value='#{emoji} 1']")
    find("input[type=submit][value='#{emoji} 1']").click
    expect(page).to have_selector("input[type=submit][value='#{emoji} 0']")
  end
end
