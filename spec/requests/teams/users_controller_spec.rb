# frozen_string_literal: true

require './spec/support/sign_in_out_request_helpers'
require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::UsersController, type: :request do
  include SignInOutRequestHelpers

  let(:team) { FactoryBot.create(:team) }

  describe 'POST create' do
    subject(:post_create) { post "/teams/#{team.id}/users", params: { user: { email: email } } }

    context 'when user is authenticated' do
      let(:browsing_user) { FactoryBot.create(:user) }

      before do
        sign_in(browsing_user)
      end

      context 'when user is authorized' do
        before do
          team.users << browsing_user
        end

        context 'when user is registered' do
          let(:user) { FactoryBot.create(:user) }
          let(:email) { user.email }
          let(:name) { user.name }

          it 'adds the user to the team' do
            expect { post_create }.to change { user.reload.team_id }.from(nil).to(team.id)
          end

          it 'enqueues welcome email' do
            expect { post_create }.to have_enqueued_mail(UserMailer, :welcome_email).with(
              a_hash_including(params: { user: user })
            ).on_queue(:default)
          end

          it 'sets the flash' do
            post_create

            expect(controller.flash[:success]).to eq('User was successfully added to the team.')
          end

          it 'redirects to edit team path' do
            post_create

            expect(response).to redirect_to(edit_team_path(team))
          end
        end

        context 'when user is not registered' do
          let(:email) { 'test@example.com' }
          let(:name) { 'Test Person' }

          it 'creates the user' do
            expect { post_create }.to change(User, :count).from(1).to(2)
          end

          it 'adds the new user to the team' do
            post_create

            expect(User.last.team_id).to eq(team.id)
          end

          it 'enqueues welcome email' do
            expect { post_create }.to have_enqueued_mail(UserMailer, :welcome_email).with(
              a_hash_including(params: { user: instance_of(User) })
            ).on_queue(:default)
          end

          it 'sets the flash' do
            post_create

            expect(controller.flash[:success]).to eq('User was successfully added to the team.')
          end

          it 'redirects to edit team path' do
            post_create

            expect(response).to redirect_to(edit_team_path(team))
          end
        end
      end

      context 'when user is not authorized' do
        let(:email) { 'test@example.com' }
        let(:name) { 'Test Person' }

        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      let(:email) { 'test@example.com' }
      let(:name) { 'Test Person' }

      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end

  describe 'DELETE destroy' do
    subject(:delete_destroy) { delete "/teams/#{team.id}/users/#{user.id}" }

    let(:user) { FactoryBot.create(:user) }

    before do
      team.users << user
    end

    context 'when user is authenticated' do
      let(:browsing_user) { FactoryBot.create(:user) }

      before do
        sign_in(browsing_user)
      end

      context 'when user is authorized' do
        before do
          team.users << browsing_user
        end

        context 'when not removing self' do
          it 'removes the user from the team' do
            expect { delete_destroy }.to change { user.reload.team_id }.from(team.id).to(nil)
          end

          it 'sets the flash' do
            delete_destroy

            expect(controller.flash[:success]).to eq('User was successfully removed from the team.')
          end

          it 'redirects back' do
            delete_destroy

            expect(response).to redirect_to(edit_team_path(team))
          end
        end

        context 'when removing self' do
          let(:user) { browsing_user }

          it 'does not remove self from team' do
            expect { delete_destroy }.not_to change { user.reload.team_id }.from(team.id)
          end

          it 'sets the flash' do
            delete_destroy

            expect(controller.flash[:warning]).to eq('You are not authorized.')
          end

          it 'redirects back (to root)' do
            delete_destroy

            expect(response).to redirect_to(root_path)
          end
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
end
