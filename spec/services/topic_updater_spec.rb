# frozen_string_literal: true

RSpec.describe TopicUpdater, type: :service do
  let(:service) { described_class.new(user, topic, { description: description, outcome: outcome }) }
  let(:user) { FactoryBot.create(:user) }
  let(:team) { FactoryBot.create(:team) }

  describe '#call' do
    subject(:call) { service.call }

    context 'when topic is being created' do
      let(:topic) { FactoryBot.build(:topic, user: user, team: team) }
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

        it 'parses the description markdown' do
          expect { call }.to change(topic, :description_html).to("<p><strong>bold</strong></p>\n")
        end

        it 'subscribes the user to the topic' do
          call

          expect(user.subscribed_topics).to contain_exactly(topic)
        end

        it 'does not create a notification for topic creator' do
          expect { call }.not_to change { user.reload.notifications.count }.from(0)
        end

        context 'someone is subscribed' do
          let(:other_user) { FactoryBot.create(:user) }
          before do
            topic.subscribed_users << other_user
          end

          it 'creates a notification' do
            expect { call }.to change { other_user.reload.notifications.count }.from(0)
          end
        end

        context 'when outcome is not empty' do
          let(:outcome) { '__bold__' }

          it 'parses the outcome markdown' do
            expect { call }.to change(topic, :outcome_html).to("<p><strong>bold</strong></p>\n")
          end
        end

        context 'when outcome is empty' do
          let(:outcome) { '' }

          before do
            topic.update!(outcome: 'bold', outcome_html: '<p><strong>bold</strong></p>')
          end

          it 'parses the outcome markdown' do
            expect { call }.to change(topic, :outcome).to(nil)
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

        it 'does not create a notification' do
          expect { call }.not_to change(Notification, :count).from(0)
        end
      end
    end

    context 'when topic is being updated' do
      let(:topic) { FactoryBot.create(:topic) }
      let(:outcome) { nil }

      before do
        topic.subscribed_users << FactoryBot.create(:user)
      end

      context 'when parameters are valid' do
        let(:description) { '__bold__' }

        it 'parses the description markdown' do
          expect { call }.to change(topic, :description_html).to("<p><strong>bold</strong></p>\n")
        end

        it 'does not subscribe user to the topic' do
          call

          expect(user.subscribed_topics).to be_empty
        end

        it 'creates a notification' do
          expect { call }.to change(Notification, :count).from(0).to(1)
        end

        it 'does not create a notification for update author' do
          expect { call }.not_to change { user.reload.notifications.count }.from(0)
        end

        context 'when outcome is not empty' do
          let(:outcome) { '__bold__' }

          it 'parses the outcome markdown' do
            expect { call }.to change(topic, :outcome_html).to("<p><strong>bold</strong></p>\n")
          end
        end

        context 'when outcome is empty' do
          let(:outcome) { '' }

          before do
            topic.update!(outcome: 'bold', outcome_html: '<p><strong>bold</strong></p>')
          end

          it 'parses the outcome markdown' do
            expect { call }.to change(topic, :outcome).to(nil)
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

        it 'does not create a notification' do
          expect { call }.not_to change(Notification, :count).from(0)
        end
      end
    end
  end
end
