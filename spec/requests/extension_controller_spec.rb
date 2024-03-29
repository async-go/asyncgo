# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe ExtensionController, type: :request do
  describe 'GET new_topic' do
    subject(:get_new_topic) do
      get '/extension/new_topic', params: { selection: 'Hello', context: 'https://www.google.com' }
    end

    let(:user) { create(:user) }

    before do
      sign_in(user)
    end

    context 'when user is authorized' do
      before do
        user.update!(team: create(:team))
      end

      it 'persists the selection and context query parameters' do
        get_new_topic

        expect(response).to redirect_to(
          new_team_topic_path(user.team, params: { selection: 'Hello', context: 'https://www.google.com' })
        )
      end
    end

    include_examples 'unauthorized user examples'
  end
end
