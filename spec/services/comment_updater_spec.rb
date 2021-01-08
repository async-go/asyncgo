# frozen_string_literal: true

RSpec.describe CommentUpdater, type: :service do
  let(:service) { described_class.new(comment, { body: '__bold__' }) }

  describe '#call' do
    subject(:call) { service.call }

    context 'when comment is being created' do
      let(:comment) { FactoryBot.build(:comment) }

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
    end

    context 'when comment is being updated' do
      let(:comment) { FactoryBot.create(:comment) }

      it 'parses the body markdown' do
        expect { call }.to change(comment, :body_html).to("<p><strong>bold</strong></p>\n")
      end
    end
  end
end
