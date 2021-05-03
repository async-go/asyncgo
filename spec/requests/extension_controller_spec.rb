# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe ExtensionController, type: :request do
  describe 'POST new_topic' do
    subject(:post_new_topic) do
      post '/extension/new_topic', params: { selection: 'Hello', context: 'https://www.google.com' }, as: :json
    end

    let(:user) { FactoryBot.create(:user) }

    before do
      sign_in(user)
    end

    context 'when user is authorized' do
      before do
        user.update!(team: FactoryBot.create(:team))
      end

      it 'persists the selection and context query parameters' do
        post_new_topic

        expect(response).to redirect_to(
          new_team_topic_path(user.team, params: { selection: 'Hello', context: 'https://www.google.com' })
        )
      end
    end

    include_examples 'unauthorized user examples'
  end
end
