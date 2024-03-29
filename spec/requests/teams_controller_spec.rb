# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe TeamsController, type: :request do
  describe 'GET edit' do
    subject(:get_edit) { get "/teams/#{team.id}/edit" }

    let(:team) { create(:team) }

    context 'when user is authorized' do
      before do
        sign_in(create(:user, team:))
      end

      it 'renders the edit page' do
        get_edit

        expect(response.body).to include(CGI.escapeHTML(team.name))
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'PATCH update' do
    subject(:patch_update) do
      patch "/teams/#{team.id}", params: { team: params }
    end

    let(:team) { create(:team) }

    context 'when user is authorized' do
      before do
        sign_in(create(:user, team:))
      end

      context 'when update params are valid' do
        let(:params) { { name: 'New team name', message: 'Hello' } }

        it 'updates the name' do
          expect { patch_update }.to change { team.reload.name }.from(team.name).to('New team name')
        end

        it 'updates the message' do
          expect { patch_update }.to change { team.reload.message }.from(nil).to('Hello')
        end

        it 'sets the flash' do
          patch_update

          expect(controller.flash[:success]).to eq('Team was successfully updated.')
        end
      end

      context 'when update params are not valid' do
        let(:params) { { name: 'New team name :' } }

        it 'does not update the team' do
          expect { patch_update }.not_to change(team, :name)
        end

        it 'shows the error' do
          patch_update

          expect(response.body).to include('Name is invalid')
        end
      end
    end

    include_examples 'unauthenticated user examples' do
      let(:params) { { message: 'Hello' } }
    end
  end

  describe 'GET new' do
    subject(:get_new) { get '/teams/new' }

    context 'when user is authenticated' do
      before do
        sign_in(create(:user))
      end

      it 'renders the new page' do
        get_new

        expect(response.body).to include('New Team')
      end
    end

    include_examples 'unauthenticated user examples'
  end

  describe 'POST create' do
    subject(:post_create) do
      post '/teams', params: { team: { name: } }
    end

    context 'when user is authenticated' do
      before do
        sign_in(create(:user))
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
        let(:name) { '' }

        it 'does not create the team' do
          expect { post_create }.not_to change(Team, :count).from(0)
        end

        it 'shows the error' do
          post_create

          expect(response.body).to include('Name can&#39;t be blank')
        end
      end
    end

    include_examples 'unauthenticated user examples' do
      let(:name) { 'Sample team' }
    end
  end

  describe 'POST support' do
    subject(:post_support) do
      post "/teams/#{team.id}/support", params: { body: 'test' }
    end

    let(:team) { create(:team) }

    context 'when user is authorized' do
      let(:user) { create(:user, team:) }

      before do
        sign_in(user)
      end

      it 'enqueues support email' do
        expect { post_support }.to have_enqueued_mail(SupportMailer, :support_email).with(
          a_hash_including(params: { user:, body: 'test' })
        ).on_queue(:default)
      end

      it 'sets the flash' do
        post_support

        expect(controller.flash[:success]).to eq('Support request was successfully sent.')
      end

      it 'redirects to edit team path' do
        post_support

        expect(response).to redirect_to(edit_team_path(team))
      end
    end

    include_examples 'unauthorized user examples'
  end
end
