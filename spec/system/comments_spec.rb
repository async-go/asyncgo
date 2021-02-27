# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Comments', type: :system do
  include SignInOutSystemHelpers

  it 'allows the user to leave comments using markdown' do
    user = FactoryBot.create(:user, :team)
    topic = FactoryBot.create(:topic, team: user.team)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title

    fill_in 'comment[body]', with: '__Sample content__'
    click_button 'Create Comment'

    expect(page).to have_selector('strong', text: 'Sample content')
  end

  it 'allows the user to update a comment' do
    user = FactoryBot.create(:user, :team)
    comment = FactoryBot.create(:comment, user: user)

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link comment.topic.title
    click_link 'Edit Comment'

    expect(page).to have_selector(
      "form[action='#{team_topic_comment_path(comment.topic.team, comment.topic, comment)}']"
    )
    fill_in 'comment[body]', with: 'This is updated content'
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
