# frozen_string_literal: true

RSpec.describe TeamsController, type: :request do
  describe 'GET edit' do
    subject(:get_edit) { get "/teams/#{team.id}/edit" }

    let(:team) { FactoryBot.create(:team) }

    it 'renders the edit page' do
      get_edit

      expect(response.body).to include(team.name)
    end
  end
end
