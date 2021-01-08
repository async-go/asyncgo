# frozen_string_literal: true

RSpec.describe TopicUpdater, type: :service do
  let(:service) { described_class.new(topic, { description: '__bold__', decision: decision }) }

  describe '#call' do
    subject(:call) { service.call }

    context 'when comment is being created' do
      let(:topic) { FactoryBot.build(:topic) }
      let(:decision) { nil }

      it 'creates a comment' do
        expect { call }.to change(Topic, :count).from(0).to(1)
      end

      it 'saves the comment' do
        call

        expect(topic).to be_persisted
      end

      it 'parses the description markdown' do
        expect { call }.to change(topic, :description_html).to("<p><strong>bold</strong></p>\n")
      end

      context 'when decision is not empty' do
        let(:decision) { '__bold__' }

        it 'parses the decision markdown' do
          expect { call }.to change(topic, :decision_html).to("<p><strong>bold</strong></p>\n")
        end
      end

      context 'when decision is empty' do
        let(:decision) { '' }

        before do
          topic.update!(decision: 'bold', decision_html: '<p><strong>bold</strong></p>')
        end

        it 'parses the decision markdown' do
          expect { call }.to change(topic, :decision).to(nil)
        end
      end
    end

    context 'when comment is being updated' do
      let(:topic) { FactoryBot.create(:topic) }
      let(:decision) { nil }

      it 'parses the description markdown' do
        expect { call }.to change(topic, :description_html).to("<p><strong>bold</strong></p>\n")
      end

      context 'when decision is not empty' do
        let(:decision) { '__bold__' }

        it 'parses the decision markdown' do
          expect { call }.to change(topic, :decision_html).to("<p><strong>bold</strong></p>\n")
        end
      end

      context 'when decision is empty' do
        let(:decision) { '' }

        before do
          topic.update!(decision: 'bold', decision_html: '<p><strong>bold</strong></p>')
        end

        it 'parses the decision markdown' do
          expect { call }.to change(topic, :decision).to(nil)
        end
      end
    end
  end
end
