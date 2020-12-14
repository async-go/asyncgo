# frozen_string_literal: true

require './spec/support/sign_in_out_system_helpers'

RSpec.describe 'Topics', type: :system do
  include SignInOutSystemHelpers

  it 'shows all topics' do
    topics = FactoryBot.create_list(:topic, 2)
    visit '/topics'

    topics.each do |topic|
      expect(page).to have_link(topic.title)
    end
  end

  it 'allows the user to create a topic' do
    visit '/'
    sign_in_user

    click_link 'Topics'

    click_link 'New Topic'

    fill_in 'topic[title]', with: 'Sample title'
    click_button 'Submit'

    expect(page).to have_text('Sample title')
  end

  it 'allows the user to leave comments on topic' do
    visit '/'

    sign_in_user
    topic = FactoryBot.create(:topic)

    click_link 'Topics'

    click_link topic.title

    click_link 'New Comment'

    fill_in 'comment[body]', with: 'Sample content'
    click_button 'Submit'

    expect(page).to have_text('Sample content')
  end
end
