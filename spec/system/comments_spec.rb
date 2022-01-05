# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Comments', type: :system do
  include SignInOutSystemHelpers

  it 'allows the user to leave comments using markdown' do
    user = create(:user, :team)
    topic = create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title

    within('[data-target="comment_body"]') do
      click_button 'Markdown'
      find('.CodeMirror').click
      page.send_keys('__Sample content__')
    end

    click_button 'Add Comment'

    expect(page).to have_selector('strong', text: 'Sample content')
  end

  it 'allows the user to update a comment' do
    user = create(:user, :team)
    comment = create(:comment, user:)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link comment.topic.title
    click_link 'Edit', href: edit_team_topic_comment_path(comment.topic.team, comment.topic, comment)

    edit_comment_path = team_topic_comment_path(comment.topic.team, comment.topic, comment)
    edit_comment_form = find("form[action='#{edit_comment_path}']", match: :first)
    within(edit_comment_form) do
      within('[data-target="comment_body"]') do
        find('.tui-editor-contents').set('This is updated content')
      end
      click_button 'Update'
    end

    expect(page).to have_text('This is updated content')
  end

  it 'allows the user to delete a comment' do
    user = create(:user, :team)
    comment = create(:comment, user:)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link comment.topic.title
    expect(page).to have_text(comment.body)
    accept_alert do
      click_link 'Delete', href: team_topic_comment_archive_path(comment.topic.team, comment.topic, comment)
    end
    expect(page).not_to have_text(comment.body)
  end

  it 'prevents uploading image data' do
    user = create(:user, :team)
    topic = create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title

    within('[data-target="comment_body"]') do
      click_button 'Markdown'
      find('.CodeMirror').click
      page.send_keys('![image.png](data:image/png;base64,abcdefg)')
    end
    click_button 'Add Comment'

    expect(page).to have_text("Body can't contain embedded markdown images")
  end

  it 'allows the user to vote on comments' do
    user = create(:user, :team)
    comment = create(:comment, user:)

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

    expect(page).to have_selector("input[type=submit][value='#{emoji} 1']")
    remove_upvote_path = "#{upvote_path}/#{comment.votes.last.id}"
    remove_upvote_form = find("form[action='#{remove_upvote_path}']", match: :first)
    within(remove_upvote_form) do
      find("input[type=submit][value='#{emoji} 1']").click
    end

    within(upvote_form) do
      expect(page).to have_selector("input[type=submit][value='#{emoji} 0']")
    end
  end
end
