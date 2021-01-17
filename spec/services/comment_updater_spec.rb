# frozen_string_literal: true

RSpec.describe CommentUpdater, type: :service do
  let(:service) { described_class.new(comment.user, comment, params) }

  describe '#call' do
    subject(:call) { service.call }

    context 'when comment is being created' do
      let(:comment) { FactoryBot.build(:comment) }

      context 'when parameters are valid' do
        let(:params) { { body: '__bold__' } }

        it 'creates a comment' do
          expect { call }.to change(Comment, :count).from(0).to(1)
        end

        it 'saves the comment' do
          call

          expect(comment).to be_persisted
        end

        it 'parses the body markdown' do
          expect { call }.to change(comment, :body_html).to("<p><strong>bold</strong></p>\n")
        end

        it 'subscribes the user to the topic' do
          call

          expect(comment.user.subscribed_topics).to contain_exactly(comment.topic)
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
      end
    end

    context 'when comment is being updated' do
      let(:comment) { FactoryBot.create(:comment) }

      context 'when parameters are valid' do
        let(:params) { { body: '__bold__' } }

        it 'parses the body markdown' do
          expect { call }.to change(comment, :body_html).to("<p><strong>bold</strong></p>\n")
        end

        it 'does not subscribe user to the topic' do
          call

          expect(comment.user.subscribed_topics).to be_empty
        end
      end

      context 'when parameters are not valid' do
        let(:params) { { body: nil } }

        it 'does not update the comment' do
          expect { call }.not_to change(comment, :body_html)
        end

        it 'does not subscribe user to the topic' do
          call

          expect(comment.user.subscribed_topics).to be_empty
        end
      end
    end
  end
end
