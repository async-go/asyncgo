# frozen_string_literal: true

RSpec.describe 'Homepage', type: :system do
  it 'shows the homepage' do
    visit '/'

    expect(page).to have_text('Welcome to AsyncGo')
  end
end
