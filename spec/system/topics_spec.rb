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

    find('trix-editor#topic_description').click.set('This is updated content')
    click_button 'Update Topic'

    expect(page).to have_text('This is updated content')
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

    find('trix-editor#comment_body').click.set('This is updated content')
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
