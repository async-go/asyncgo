# frozen_string_literal: true

RSpec.describe 'Topics', type: :system do
  it 'shows all topics' do
    topics = FactoryBot.create_list(:topic, 2)
    visit '/topics'

    topics.each do |topic|
      expect(page).to have_link(topic.title)
    end
  end

  it 'allows the user to create a topic' do
    FactoryBot.create(:user)

    visit '/topics'

    click_link 'New Topic'

    fill_in 'topic[title]', with: 'Sample title'
    click_button 'Submit'

    expect(page).to have_text('Sample title')
  end

  it 'allows the user to leave comments on topic' do
    topic = FactoryBot.create(:topic)

    visit '/topics'

    click_link topic.title

    click_link 'New Comment'

    fill_in 'comment[body]', with: 'Sample content'
    click_button 'Submit'

    expect(page).to have_text('Sample content')
  end
end
