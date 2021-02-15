# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Topics', type: :system do
  include SignInOutSystemHelpers

  it 'allows the user to vote on a topic' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    topic = FactoryBot.create(:topic, team: team)
    team.users << user

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

  it 'allows the user to update a comment on the topic' do
    team = FactoryBot.create(:team)
    user = FactoryBot.create(:user)
    topic = FactoryBot.create(:topic, team: team)
    comment = FactoryBot.create(:comment, topic: topic, user: user)
    team.users << user

    visit '/'
    sign_in_user(user)
    click_link 'Topics'
    click_link topic.title

    emoji = Emoji.find_by_alias('thumbsup').raw # rubocop:disable Rails/DynamicFindBy
    upvote_path = team_topic_comment_votes_path(team, topic, comment)
    upvote_form = find("form[action='#{upvote_path}']", match: :first)
    within(upvote_form) do
      expect(page).to have_selector("input[type=submit][value='#{emoji} 0']")
      find("input[type=submit][value='#{emoji} 0']").click
    end

    remove_upvote_path = "#{upvote_path}/1"
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
