# frozen_string_literal: true

require './spec/support/sign_in_out_request_helpers'
require './spec/support/unauthorized_user_examples'

RSpec.describe Users::NotificationsController, type: :request do
  include SignInOutRequestHelpers

  describe 'GET show' do
    subject(:get_show) { get "/users/#{user.id}/notifications/#{notification.id}" }

    let(:user) { FactoryBot.create(:user, :team) }
    let(:topic) { FactoryBot.create(:topic, team: user.team) }
    let(:notification) { FactoryBot.create(:notification) }

    context 'when user is authenticated' do
      before do
        sign_in(user)
      end

      context 'when user is authorized' do
        before do
          notification.update!(user: user)
        end

        context 'when target is topic' do
          before do
            notification.update!(target: topic)
          end

          it 'redirects to target topic' do
            get_show

            expect(response).to redirect_to(team_topic_path(topic.team, topic))
          end

          it 'marks notification as read' do
            expect { get_show }.to change { notification.reload.read_at }.from(nil)
          end
        end

        context 'when target is comment' do
          before do
            notification.update!(target: FactoryBot.create(:comment, topic: topic))
          end

          it 'redirects to target comment topic' do
            get_show

            expect(response).to redirect_to(team_topic_path(topic.team, topic))
          end

          it 'marks notification as read' do
            expect { get_show }.to change { notification.reload.read_at }.from(nil)
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

  describe 'POST clear' do
    subject(:post_clear) { post "/users/#{user.id}/notifications/clear" }

    let(:user) { FactoryBot.create(:user) }

    before do
      FactoryBot.create(:notification, user: user)
    end

    context 'when user is authenticated' do
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

    context 'when user is not authenticated' do
      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end
end
