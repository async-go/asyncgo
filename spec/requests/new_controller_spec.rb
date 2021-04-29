# frozen_string_literal: true

require './spec/support/sign_in_out_request_helpers'

RSpec.describe NewController, type: :request do
  include SignInOutRequestHelpers

  describe 'GET topic' do
    subject(:get_new_topic) { get '/new/topic' }

    let(:team) { FactoryBot.create(:team) }
    let(:user) { FactoryBot.create(:user, team: team) }

    context 'when user is authorized' do
      before do
        sign_in(user)
      end

      it 'redirects to the new topic page' do
        get_new_topic

        expect(response.body).to redirect_to(new_team_topic_path(user.team))
      end

      context 'when query parameters are set' do
        subject(:get_new_topic) { get '/new/topic', params: { selection: 'Hello', context: 'https://www.google.com' } }

        it 'persists the selection and context query parameters' do
          get_new_topic

          expect(response).to redirect_to(new_team_topic_path(user.team,
                                                              params: { selection: 'Hello',
                                                                        context: 'https://www.google.com' }))
        end
      end
    end

    context 'when the user is not logged in' do
      it 'redirects to the home page' do
        get_new_topic

        expect(response.body).to redirect_to('/')
      end
    end
  end
end
