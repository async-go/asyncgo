# frozen_string_literal: true

RSpec.describe TopicUpdater, type: :service do
  let(:service) { described_class.new(user, topic, { description: description, outcome: outcome }) }
  let(:user) { FactoryBot.create(:user) }

  describe '#call' do
    subject(:call) { service.call }

    context 'when topic is being created' do
      let(:topic) { FactoryBot.build(:topic) }
      let(:outcome) { nil }

      context 'when parameters are valid' do
        let(:description) { '__bold__' }

        it 'creates a topic' do
          expect { call }.to change(Topic, :count).from(0).to(1)
        end

        it 'saves the topic' do
          call

          expect(topic).to be_persisted
        end

        it 'subscribes the user to the topic' do
          call

          expect(user.subscribed_topics).to contain_exactly(topic)
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

      context 'when parameters are not valid' do
        let(:description) { nil }

        it 'does not update the topic' do
          expect { call }.not_to change(topic, :description)
        end

        it 'does not subscribe user to the topic' do
          call

          expect(user.subscribed_topics).to be_empty
        end
      end
    end
  end
end
