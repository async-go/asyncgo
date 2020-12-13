# frozen_string_literal: true

RSpec.describe 'Team settings', type: :system do
  let(:team) { FactoryBot.create(:team) }

  it 'allows the user to add other users to the team' do
    user = FactoryBot.create(:user)
    visit "/teams/#{team.id}/edit"

    select user.username, from: 'add-user'
    click_button 'Add User'

    expect(page).to have_link("Remove #{user.username}")
  end

  it 'allows the user to remove users from the team' do
    user = FactoryBot.create(:user)
    team.users << user

    visit "/teams/#{team.id}/edit"

    click_link "Remove #{user.username}"

    expect(page).to have_select('add-user', with_options: [user.username])
  end
end
