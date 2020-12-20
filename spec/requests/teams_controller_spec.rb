# frozen_string_literal: true

require './spec/support/sign_in_out_request_helpers'
require './spec/support/unauthorized_user_examples'

RSpec.describe TeamsController, type: :request do
  include SignInOutRequestHelpers

  describe 'GET edit' do
    subject(:get_edit) { get "/teams/#{team.id}/edit" }

    let(:team) { FactoryBot.create(:team) }

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in(user)
      end

      context 'when user is authorized' do
        before do
          team.users << user
        end

        it 'renders the edit page' do
          get_edit

          expect(response.body).to include(team.name)
        end
      end

      context 'when user is not authorized' do
        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end

  describe 'GET new' do
    subject(:get_new) { get '/teams/new' }

    context 'when user is authenticated' do
      before do
        sign_in(FactoryBot.create(:user))
      end

      it 'renders the new page' do
        get_new

        expect(response.body).to include('New Team')
      end
    end

    context 'when user is not authenticated' do
      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end

  describe 'POST create' do
    subject(:post_create) do
      post '/teams', params: { team: { name: name } }
    end

    context 'when user is authenticated' do
      before do
        sign_in(FactoryBot.create(:user))
      end

      context 'when team is valid' do
        let(:name) { 'Sample team' }

        it 'creates the team' do
          expect { post_create }.to change(Team, :count).from(0).to(1)
        end

        it 'sets the flash' do
          post_create

          expect(controller.flash[:success]).to eq('Team was successfully created.')
        end

        it 'redirects to team' do
          post_create

          expect(response).to redirect_to(edit_team_path(Team.last.id))
        end
      end

      context 'when team is not valid' do
        let(:title) { '' }

        it 'does not create the team' do
          expect { post_create }.not_to change(Team, :count).from(0)
        end

        it 'shows the error' do
          post_create

          expect(response.body).to include('Name can&#39;t be blank')
        end
      end
    end

    context 'when user is not authenticated' do
      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end
end
