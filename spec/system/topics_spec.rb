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
    click_button 'Create Topic'

    expect(page).to have_text('Sample title')
    expect(page.body).to include('<strong>Sample topic content</strong>')
  end

  it 'allows the user to edit a topic' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit Topic Context'

    fill_in 'topic[description]', with: 'This is an update'
    click_button 'Update Topic'

    expect(page).to have_text('This is an update')
  end

  it 'prevents overwriting topic updates for description' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit Topic Context'

    fill_in 'topic[description]', with: 'This is an update'
    topic.update!(description: 'This is an external update',
                  description_checksum: Digest::MD5.hexdigest(topic.description))
    click_button 'Update Topic'

    expect(page).to have_text('Description was changed by somebody else and you can no longer save. Open this same '\
      'topic in a new tab and merge your changes manually (do not refresh this page or your changes will be lost.)')
  end

  it 'prevents overwriting topic updates for outcome' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit Topic Context'

    fill_in 'topic[outcome]', with: 'This is an update'
    topic.update!(outcome: 'This is an external update',
                  outcome_checksum: Digest::MD5.hexdigest(topic.outcome))
    click_button 'Update Topic'

    expect(page).to have_text('Outcome was changed by somebody else and you can no longer save. Open this same topic '\
      'in a new tab and merge your changes manually (do not refresh this page or your changes will be lost.)')
  end

  it 'allows the user to summarize an outcome using markdown' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit Topic Context'

    fill_in 'topic[outcome]', with: '__Sample outcome__'
    click_button 'Update Topic'

    expect(page.body).to include('<strong>Sample outcome</strong>')
  end

  it 'allows the user to close and open the topic' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_button 'Resolve Topic'
    click_button 'Reopen Topic'

    expect(page).to have_button('Resolve Topic')
  end

  it 'allows the user to subscribe and unsubscribe from the topic' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

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

  it 'allows the user to leave comments using markdown' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title

    fill_in 'comment[body]', with: '__Sample content__'
    click_button 'Create Comment'

    expect(page.body).to include('<strong>Sample content</strong>')
  end

  it 'allows the user to update a comment' do
    user = FactoryBot.create(:user, :team)
    comment = FactoryBot.create(:comment, user: user)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link comment.topic.title
    click_link 'Edit Comment'

    find(:fillable_field, 'comment[body]').send_keys('This is updated content')
    click_button 'Update Comment'

    expect(page).to have_text('This is updated content')
  end

  it 'allows the user to vote on comments' do
    user = FactoryBot.create(:user, :team)
    comment = FactoryBot.create(:comment, user: user)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link comment.topic.title

    emoji = Emoji.find_by_alias('thumbsup').raw # rubocop:disable Rails/DynamicFindBy
    upvote_path = team_topic_comment_votes_path(comment.topic.team, comment.topic, comment)
    upvote_form = find("form[action='#{upvote_path}']", match: :first)
    within(upvote_form) do
      expect(page).to have_selector("input[type=submit][value='#{emoji} 0']")
      find("input[type=submit][value='#{emoji} 0']").click
    end

    remove_upvote_path = "#{upvote_path}/#{comment.votes.last.id}"
    remove_upvote_form = find("form[action='#{remove_upvote_path}']", match: :first)
    within(remove_upvote_form) do
      expect(page).to have_selector("input[type=submit][value='#{emoji} 1']")
      find("input[type=submit][value='#{emoji} 1']").click
    end

    within(upvote_form) do
      expect(page).to have_selector("input[type=submit][value='#{emoji} 0']")
    end
  end
end
