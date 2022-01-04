# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::UsersController, type: :request do
  let(:team) { create(:team) }

  describe 'GET index' do
    subject(:get_index) { get "/teams/#{team.id}/users.json" }

    context 'when user is authorized' do
      let(:user) { create(:user, team:) }

      before do
        sign_in(user)
      end

      it 'renders a json list of users' do
        get_index

        expect(JSON.parse(response.body)).to include(
          a_hash_including('key' => user.printable_name, 'value' => user.email)
        )
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'POST create' do
    subject(:post_create) { post "/teams/#{team.id}/users", params: { user: { email: } } }

    context 'when user is authorized' do
      before do
        sign_in(create(:user, team:))
      end

      context 'when team has 5 users' do
        let(:user) { create(:user) }
        let(:email) { user.email }

        before do
          create_list(:user, 4, team:)
        end

        context 'when team has active subscription' do
          before do
            team.create_subscription!(active: true)
          end

          it 'adds the user to the team' do
            expect { post_create }.to change { user.reload.team_id }.from(nil).to(team.id)
          end

          it 'sets the flash' do
            post_create

            expect(controller.flash[:success]).to eq('User was successfully added to the team.')
          end

          it 'enqueues welcome email' do
            expect { post_create }.to have_enqueued_mail(UserMailer, :welcome_email).with(
              a_hash_including(params: { user: })
            ).on_queue(:default)
          end

          it 'redirects to edit team path' do
            post_create

            expect(response).to redirect_to(edit_team_path(team))
          end
        end

        context 'when team does not have active subscription' do
          it 'does not add user to the team' do
            expect { post_create }.not_to(change { user.reload.team_id })
          end

          it 'sets the flash' do
            post_create

            expect(controller.flash[:danger]).to eq('You have reached the maximum 5 users on the free plan.')
          end

          it 'does not enqueue welcome email' do
            expect { post_create }.not_to have_enqueued_mail(UserMailer, :welcome_email).with(
              a_hash_including(params: { user: })
            ).on_queue(:default)
          end

          it 'redirects to edit team path' do
            post_create

            expect(response).to redirect_to(edit_team_path(team))
          end
        end
      end

      context 'when user is registered' do
        let(:user) { create(:user) }
        let(:email) { user.email }

        context 'when user does not belong to a team' do
          it 'adds the user to the team' do
            expect { post_create }.to change { user.reload.team_id }.from(nil).to(team.id)
          end

          it 'enqueues welcome email' do
            expect { post_create }.to have_enqueued_mail(UserMailer, :welcome_email).with(
              a_hash_including(params: { user: })
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
            user.update!(team: create(:team))
          end

          it 'does not add user to the team' do
            expect { post_create }.not_to(change { user.reload.team_id })
          end

          it 'does not enqueue welcome email' do
            expect { post_create }.not_to have_enqueued_mail(UserMailer, :welcome_email).with(
              a_hash_including(params: { user: })
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
        context 'when email is valid' do
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

        context 'when email is not valid' do
          let(:email) { 'invalidemail' }

          it 'does not create the user' do
            expect { post_create }.not_to change(User, :count).from(1)
          end

          it 'does not enqueue welcome email' do
            expect { post_create }.not_to have_enqueued_mail(UserMailer, :welcome_email)
          end

          it 'sets the flash' do
            post_create

            expect(controller.flash[:danger]).to eq(
              'There was a problem adding the user to the team. Email is invalid.'
            )
          end

          it 'redirects to edit team path' do
            post_create

            expect(response).to redirect_to(edit_team_path(team))
          end
        end
      end
    end

    include_examples 'unauthorized user examples' do
      let(:email) { 'johndoe@example.com' }
    end
  end

  describe 'DELETE destroy' do
    subject(:delete_destroy) { delete "/teams/#{team.id}/users/#{user.id}" }

    let(:user) { create(:user, team:) }

    context 'when user is authorized' do
      let(:browsing_user) { create(:user, team:) }

      before do
        sign_in(browsing_user)
      end

      context 'when there are multiple team members' do
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

      context 'when user is last team member' do
        let(:browsing_user) { user }

        it 'does not remove the user from the team' do
          expect { delete_destroy }.not_to change { user.reload.team_id }.from(team.id)
        end

        it 'sets the flash' do
          delete_destroy

          expect(controller.flash[:danger]).to eq(
            'User could not be removed from the team because he is the last user in it.'
          )
        end

        it 'redirects back' do
          delete_destroy

          expect(response).to redirect_to(edit_team_path(team))
        end
      end
    end

    include_examples 'unauthorized user examples'
  end
end
