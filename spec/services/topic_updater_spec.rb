# frozen_string_literal: true

RSpec.describe TopicUpdater, type: :service do
  let(:service) { described_class.new(user, topic, { description: description, decision: decision }) }
  let(:user) { FactoryBot.create(:user) }

  describe '#call' do
    subject(:call) { service.call }

    context 'when topic is being created' do
      let(:topic) { FactoryBot.build(:topic) }
      let(:decision) { nil }

      context 'when parameters are valid' do
        let(:description) { '__bold__' }

        it 'creates a topic' do
          expect { call }.to change(Topic, :count).from(0).to(1)
        end

        it 'saves the topic' do
          call

          expect(topic).to be_persisted
        end

        it 'parses the description markdown' do
          expect { call }.to change(topic, :description_html).to("<p><strong>bold</strong></p>\n")
        end

        it 'subscribes the user to the topic' do
          call

          expect(user.subscribed_topics).to contain_exactly(topic)
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

      context 'when parameters are not valid' do
        let(:description) { nil }

        it 'does not create the topic' do
          call

          expect(topic).not_to be_persisted
        end

        it 'does not subscribe user to the topic' do
          call

          expect(user.subscribed_topics).to be_empty
        end
      end
    end

    context 'when topic is being updated' do
      let(:topic) { FactoryBot.create(:topic) }
      let(:decision) { nil }

      context 'when parameters are valid' do
        let(:description) { '__bold__' }

        it 'parses the description markdown' do
          expect { call }.to change(topic, :description_html).to("<p><strong>bold</strong></p>\n")
        end

        it 'does not subscribe user to the topic' do
          call

          expect(user.subscribed_topics).to be_empty
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

      context 'when parameters are not valid' do
        let(:description) { nil }

        it 'does not update the topic' do
          expect { call }.not_to change(topic, :description_html)
        end

        it 'does not subscribe user to the topic' do
          call

          expect(user.subscribed_topics).to be_empty
        end
      end
    end
  end
end
