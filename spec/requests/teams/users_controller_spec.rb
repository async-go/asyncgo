# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::UsersController, type: :request do
  let(:team) { FactoryBot.create(:team) }

  describe 'POST create' do
    subject(:post_create) { post "/teams/#{team.id}/users", params: { user: { email: email } } }

    context 'when user is authorized' do
      before do
        sign_in(FactoryBot.create(:user, team: team))
      end

      context 'when user is registered' do
        let(:user) { FactoryBot.create(:user) }
        let(:email) { user.email }

        context 'when user does not belong to a team' do
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

        context 'when user belongs to a team' do
          before do
            user.update!(team: FactoryBot.create(:team))
          end

          it 'does not add user to the team' do
            expect { post_create }.not_to(change { user.reload.team_id })
          end

          it 'does not enqueue welcome email' do
            expect { post_create }.not_to have_enqueued_mail(UserMailer, :welcome_email).with(
              a_hash_including(params: { user: user })
            ).on_queue(:default)
          end

          it 'sets the flash' do
            post_create

            expect(controller.flash[:danger]).to eq('User already belongs to a team.')
          end

          it 'redirects to edit team path' do
            post_create

            expect(response).to redirect_to(edit_team_path(team))
          end
        end
      end

      context 'when user is not registered' do
        let(:email) { 'test@example.com' }

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

    include_examples 'unauthorized user examples' do
      let(:email) { 'johndoe@example.com' }
    end
  end

  describe 'DELETE destroy' do
    subject(:delete_destroy) { delete "/teams/#{team.id}/users/#{user.id}" }

    let(:user) { FactoryBot.create(:user, team: team) }

    context 'when user is authorized' do
      let(:browsing_user) { FactoryBot.create(:user, team: team) }

      before do
        sign_in(browsing_user)
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

    include_examples 'unauthorized user examples'
  end
end
