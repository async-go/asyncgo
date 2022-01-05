# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Topics', type: :system do
  include SignInOutSystemHelpers
  it 'shows all topics' do
    user = create(:user, :team)
    topics = create_list(:topic, 2, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'

    topics.each do |topic|
      expect(page).to have_link(topic.title)
    end
  end

  it 'allows the user to filter topics by label' do
    user = create(:user, :team)
    target_topic = create(:topic, team: user.team, label_list: 'hello')
    other_topic = create(:topic, team: user.team, label_list: 'world')

    visit '/'
    sign_in_user(user)
    click_link 'Topics'

    [target_topic, other_topic].each do |topic|
      expect(page).to have_link(topic.title)
    end

    expect(page).to have_field(:labels, disabled: false)
    fill_in :labels, with: 'hello'
    click_button 'Filter'
    expect(page).to have_field(:labels, disabled: true)
    expect(page).to have_link(target_topic.title)
    expect(page).not_to have_link(other_topic.title)
  end

  it 'allows the user to create a topic using markdown' do
    visit '/'
    sign_in_user(create(:user, :team))
    click_link 'Topics'
    click_link 'New Topic'

    fill_in 'topic[title]', with: 'Sample title'
    within('[data-target="topic_description"]') do
      click_button 'Markdown'
      find('.CodeMirror').click
      page.send_keys('__Sample topic content__')
    end
    click_button 'Create'

    expect(page).to have_text('Sample title')
    expect(page).to have_selector('strong', text: 'Sample topic content')
  end

  it 'allows the user to create a topic using query parameters' do
    user = create(:user, :team)
    visit '/'
    sign_in_user(user)

    visit "/teams/#{user.team.id}/topics/new?context=hello&selection=goodbye"
    fill_in 'topic[title]', with: 'Sample title'
    click_button 'Create'

    expect(page).to have_text('Created from: hello')
    expect(page).to have_text('goodbye')
  end

  it 'allows the user to delete a topic' do
    user = create(:user, :team)
    topic = create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    expect(page).to have_text(topic.title)
    accept_alert do
      click_link 'Delete', href: team_topic_archive_path(topic.team, topic)
    end
    expect(page).not_to have_text(topic.title)
  end

  it 'allows the user to edit a topic' do
    user = create(:user, :team)
    topic = create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit'

    within('[data-target="topic_description"]') do
      find('.tui-editor-contents').set('This is an update')
    end
    click_button 'Update'

    expect(page).to have_text('This is an update')
  end

  it 'prevents uploading image data to description' do
    user = create(:user, :team)
    topic = create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit'

    within('[data-target="topic_description"]') do
      click_button 'Markdown'
      find('.CodeMirror').click
      page.send_keys('![image.png](data:image/png;base64,abcdefg)')
    end
    click_button 'Update'
    expect(page).to have_text("Description can't contain embedded markdown images")
  end

  it 'prevents uploading image data to outcome' do
    user = create(:user, :team)
    topic = create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit'

    within('[data-target="topic_outcome"]') do
      click_button 'Markdown'
      find('.CodeMirror').click
      page.send_keys('![image.png](data:image/png;base64,abcdefg)')
    end
    click_button 'Update'
    expect(page).to have_text("Outcome can't contain embedded markdown images")
  end

  it 'prevents overwriting topic updates for description' do
    user = create(:user, :team)
    topic = create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit'

    update_topic_path = team_topic_path(topic.team, topic)
    expect(page).to have_selector("form[action='#{update_topic_path}']")
    within('[data-target="topic_description"]') do
      find('.tui-editor-contents').set('Sample topic description')
    end
    topic.update!(description: 'This is an external update',
                  description_html: '<p>This is an external update',
                  description_checksum: Digest::MD5.hexdigest(topic.description))
    click_button 'Update'

    expect(page).to have_text(Topic::CHECKSUM_ERROR_MESSAGE)
  end

  it 'prevents overwriting topic updates for outcome' do
    user = create(:user, :team)
    topic = create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit'

    update_topic_path = team_topic_path(topic.team, topic)
    expect(page).to have_selector("form[action='#{update_topic_path}']")
    within('[data-target="topic_outcome"]') do
      find('.tui-editor-contents').set('Sample topic outcome')
    end
    topic.update!(outcome: 'This is an external update',
                  outcome_html: '<p>This is an external update</p>',
                  outcome_checksum: Digest::MD5.hexdigest(''))
    click_button 'Update'

    expect(page).to have_text(Topic::CHECKSUM_ERROR_MESSAGE)
  end

  it 'allows the user to summarize an outcome using markdown' do
    user = create(:user, :team)
    topic = create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_link 'Edit'

    within('[data-target="topic_outcome"]') do
      click_button 'Markdown'
      find('.CodeMirror').click
      page.send_keys('__Sample outcome__')
    end
    click_button 'Update'

    expect(page).to have_selector('strong', text: 'Sample outcome')
  end

  it 'allows the user to close and open the topic' do
    user = create(:user, :team)
    topic = create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_button 'Resolve this topic'
    click_button 'Reopen this topic'

    expect(page).to have_button('Resolve this topic')
  end

  it 'allows the user to pin and unpin the topic' do
    user = create(:user, :team)
    topic = create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title
    click_button 'Pin this topic'
    click_button 'Unpin this topic'

    expect(page).to have_button('Pin this topic')
  end

  it 'allows the user to subscribe and unsubscribe from the topic' do
    user = create(:user, :team)
    topic = create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title

    expect(page).to have_button('Watch this topic')
    click_button 'Watch this topic'
    expect(page).to have_button('Unwatch this topic')
    click_button 'Unwatch this topic'
    expect(page).to have_button('Watch this topic')
  end

  it 'allows the user to vote on a topic' do
    user = create(:user, :team)
    topic = create(:topic, team: user.team)

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
