# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe Users::NotificationsController, type: :request do
  describe 'GET index' do
    subject(:get_index) { get "/users/#{user.id}/notifications" }

    let(:user) { FactoryBot.create(:user) }

    context 'when user is authorized' do
      before do
        sign_in(user)
      end

      it 'renders the index page' do
        get_index

        expect(response.body).to include('No notifications')
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'GET show' do
    subject(:get_show) { get "/users/#{notification.user.id}/notifications/#{notification.id}" }

    let(:notification) { FactoryBot.create(:notification) }

    context 'when user is authorized' do
      before do
        sign_in(notification.user)
      end

      context 'when target is topic' do
        before do
          notification.update!(target: FactoryBot.create(:topic, team: notification.user.team))
        end

        context 'when there are no duplicate notifications' do
          it 'redirects to target topic' do
            get_show

            expect(response).to redirect_to(team_topic_path(notification.target.team, notification.target))
          end

          it 'marks notification as read' do
            expect { get_show }.to change { notification.reload.read_at }.from(nil)
          end
        end

        context 'when there are duplicate notifications' do
          let(:duplicate_notification) do
            FactoryBot.create(:notification, notification.slice(:user, :actor, :action, :target))
          end

          it 'redirects to target topic' do
            get_show

            expect(response).to redirect_to(team_topic_path(notification.target.team, notification.target))
          end

          it 'marks notification as read' do
            expect { get_show }.to change { notification.reload.read_at }.from(nil)
          end

          it 'marks duplicate notifications as read' do
            expect { get_show }.to change { duplicate_notification.reload.read_at }.from(nil)
          end
        end
      end

      context 'when target is comment' do
        before do
          notification.update!(target: FactoryBot.create(:comment, user: notification.user))
        end

        context 'when there are no duplicate notifications' do
          it 'redirects to target comment topic' do
            get_show

            expect(response).to redirect_to(team_topic_path(notification.target.topic.team, notification.target.topic))
          end

          it 'marks notification as read' do
            expect { get_show }.to change { notification.reload.read_at }.from(nil)
          end
        end

        context 'when there are duplicate notifications' do
          let(:duplicate_notification) do
            FactoryBot.create(:notification, notification.slice(:user, :actor, :action, :target))
          end

          it 'redirects to target comment topic' do
            get_show

            expect(response).to redirect_to(team_topic_path(notification.target.topic.team, notification.target.topic))
          end

          it 'marks notification as read' do
            expect { get_show }.to change { notification.reload.read_at }.from(nil)
          end

          it 'marks duplicate notifications as read' do
            expect { get_show }.to change { duplicate_notification.reload.read_at }.from(nil)
          end
        end
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'POST clear' do
    subject(:post_clear) { post "/users/#{user.id}/notifications/clear" }

    let(:user) { FactoryBot.create(:user, :team) }

    before do
      FactoryBot.create(:notification, user: user)
    end

    context 'when user is authorized' do
      before do
        sign_in(user)
      end

      it 'clears users notifications' do
        expect { post_clear }.to change { user.reload.notifications.where(read_at: nil).count }.from(1).to(0)
      end

      it 'redirects back (to root)' do
        expect(post_clear).to redirect_to(root_path)
      end
    end

    include_examples 'unauthorized user examples'
  end
end
