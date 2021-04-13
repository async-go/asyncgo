# frozen_string_literal: true

RSpec.describe TopicUpdater, type: :service do
  let(:user) { FactoryBot.create(:user, :team) }
  let(:other_user) { FactoryBot.create(:user, team: user.team) }

  describe '#call' do
    subject(:call) { described_class.new(user, topic, params).call }

    context 'when topic is being created' do
      let(:topic) { FactoryBot.build(:topic, user: user, team: user.team) }

      context 'when parameters are valid' do
        let(:params) { { description: '__bold__' } }

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

        it 'creates a notification for team members' do
          expect { call }.to change { other_user.reload.notifications.count }.from(0).to(1)
        end

        it 'creates created notifications' do
          call

          expect(Notification.all).to all(have_attributes(action: 'created'))
        end

        context 'when outcome is not empty' do
          let(:params) { { description: '__bold__', outcome: '__bold__' } }

          it 'parses the outcome markdown' do
            expect { call }.to change(topic, :outcome_html).to("<p><strong>bold</strong></p>\n")
          end
        end

        context 'when outcome is empty' do
          let(:params) { { description: '__bold__', outcome: '' } }

          before do
            topic.update!(outcome: 'bold', outcome_html: '<p><strong>bold</strong></p>')
          end

          it 'parses the outcome markdown' do
            expect { call }.to change(topic, :outcome).to(nil)
          end
        end
      end

      context 'when parameters are not valid' do
        let(:params) { { description: nil } }

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
      let(:topic) { FactoryBot.create(:topic, team: user.team) }

      before do
        topic.subscribed_users << FactoryBot.create(:user)
      end

      context 'when parameters are valid' do
        let(:params) do
          { description: '__bold__',
            description_checksum: Digest::MD5.hexdigest(topic.description) }
        end

        it 'parses the description markdown' do
          expect { call }.to change(topic, :description_html).to("<p><strong>bold</strong></p>\n")
        end

        it 'does not subscribe user to the topic' do
          call

          expect(user.subscribed_topics).to be_empty
        end

        it 'creates a notification' do
          expect { call }.to change(Notification, :count).from(0).to(2)
        end

        it 'creates updated notifications' do
          call

          expect(Notification.all).to all(have_attributes(action: 'updated'))
        end

        it 'does not create a notification for update author' do
          expect { call }.not_to change { user.reload.notifications.count }.from(0)
        end

        it 'does not create a notification for team members' do
          expect { call }.not_to change { other_user.reload.notifications.count }.from(0)
        end

        context 'when outcome is not empty' do
          let(:params) do
            { outcome: '__bold__',
              outcome_checksum: Digest::MD5.hexdigest('') }
          end

          it 'parses the outcome markdown' do
            expect { call }.to change(topic, :outcome_html).to("<p><strong>bold</strong></p>\n")
          end
        end

        context 'when outcome is empty' do
          let(:params) do
            { outcome: '',
              outcome_checksum: Digest::MD5.hexdigest('bold') }
          end

          before do
            topic.update!(
              outcome: 'bold', outcome_html: '<p><strong>bold</strong></p>',
              outcome_checksum: Digest::MD5.hexdigest('')
            )
          end

          it 'parses the outcome markdown' do
            expect { call }.to change(topic, :outcome).to(nil)
          end
        end
      end

      context 'when parameters are not valid' do
        let(:params) do
          { description: nil,
            description_checksum: Digest::MD5.hexdigest(topic.description) }
        end

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

    context 'when topic is being resolved' do
      let(:topic) { FactoryBot.create(:topic, team: user.team, status: :active) }
      let(:params) { { status: 'closed' } }

      before do
        topic.subscribed_users << FactoryBot.create(:user)
      end

      it 'does not subscribe user to the topic' do
        call

        expect(user.subscribed_topics).to be_empty
      end

      it 'creates a notification' do
        expect { call }.to change(Notification, :count).from(0).to(2)
      end

      it 'creates resolved notifications' do
        call

        expect(Notification.all).to all(have_attributes(action: 'resolved'))
      end

      it 'does not create a notification for update author' do
        expect { call }.not_to change { user.reload.notifications.count }.from(0)
      end

      it 'does not create a notification for team members' do
        expect { call }.not_to change { other_user.reload.notifications.count }.from(0)
      end
    end

    context 'when topic is being reopend' do
      let(:topic) { FactoryBot.create(:topic, team: user.team, status: :closed) }
      let(:params) { { status: 'active' } }

      before do
        topic.subscribed_users << FactoryBot.create(:user)
      end

      it 'does not subscribe user to the topic' do
        call

        expect(user.subscribed_topics).to be_empty
      end

      it 'creates a notification' do
        expect { call }.to change(Notification, :count).from(0).to(2)
      end

      it 'creates reopened notifications' do
        call

        expect(Notification.all).to all(have_attributes(action: 'reopened'))
      end

      it 'does not create a notification for update author' do
        expect { call }.not_to change { user.reload.notifications.count }.from(0)
      end

      it 'does not create a notification for team members' do
        expect { call }.not_to change { other_user.reload.notifications.count }.from(0)
      end
    end
  end
end
