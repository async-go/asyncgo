# frozen_string_literal: true

RSpec.describe CommentUpdater, type: :service do
  let(:service) { described_class.new(user, comment, params) }
  let(:user) { FactoryBot.create(:user) }
  let(:topic) { FactoryBot.create(:topic) }

  before do
    topic.subscribed_users << FactoryBot.create(:user)
  end

  describe '#call' do
    subject(:call) { service.call }

    context 'when comment is being created' do
      let(:comment) { FactoryBot.build(:comment, topic: topic, user: user) }

      context 'when parameters are valid' do
        let(:params) { { body: '__bold__' } }

        it 'creates a comment' do
          expect { call }.to change(Comment, :count).from(0).to(1)
        end

        it 'saves the comment' do
          call

          expect(comment).to be_persisted
        end

        it 'subscribes the user to the topic' do
          call

          expect(user.subscribed_topics).to contain_exactly(comment.topic)
        end

        it 'creates a notification' do
          expect { call }.to change(Notification, :count).from(0).to(1)
        end

        it 'does not create a notification for comment author' do
          expect { call }.not_to change { user.reload.notifications.count }.from(0)
        end
      end

      context 'when parameters are not valid' do
        let(:params) { { body: nil } }

        it 'does not create the comment' do
          call

          expect(comment).not_to be_persisted
        end

        it 'does not subscribe user to the topic' do
          call

          expect(comment.user.subscribed_topics).to be_empty
        end

        it 'does not create a notification' do
          expect { call }.not_to change(Notification, :count).from(0)
        end
      end
    end

    context 'when comment is being updated' do
      let(:comment) { FactoryBot.create(:comment, topic: topic, user: user) }

      context 'when parameters are valid' do
        let(:params) { { body: '__bold__' } }

        it 'does not subscribe user to the topic' do
          call

          expect(comment.user.subscribed_topics).to be_empty
        end

        it 'creates a notification' do
          expect { call }.to change(Notification, :count).from(0).to(1)
        end

        it 'does not create a notification for comment author' do
          expect { call }.not_to change { user.reload.notifications.count }.from(0)
        end
      end

      context 'when parameters are not valid' do
        let(:params) { { body: nil } }

        it 'does not update the comment' do
          expect { call }.not_to change(comment, :body)
        end

        it 'does not subscribe user to the topic' do
          call

          expect(comment.user.subscribed_topics).to be_empty
        end

        it 'does not create a notification' do
          expect { call }.not_to change(Notification, :count).from(0)
        end
      end
    end
  end
end
