# frozen_string_literal: true

RSpec.describe DigestEmailSender, type: :service do
  let!(:user) { FactoryBot.create(:user, :team) }

  let(:recently_resolved_topic) do
    FactoryBot.create(:topic, status: :resolved, updated_at: 4.hours.ago, user: user, team: user.team)
  end
  let(:unread_notification) do
    FactoryBot.create(:notification, user: user, actor: user, target: recently_resolved_topic)
  end

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#call' do
    subject(:call) { described_class.new.call }

    it 'does not create digests for users that disabled it' do
      unread_notification
      user.preferences.update!(digest_enabled: false)

      expect { call }.not_to have_enqueued_mail(DigestMailer, :digest_email)
    end

    it 'does not create digest when there are no notifications or topics' do
      expect { call }.not_to have_enqueued_mail(DigestMailer, :digest_email)
    end

    it 'creates digest when there are recently reseolved topics' do
      recently_resolved_topic

      expect { call }.to have_enqueued_mail(DigestMailer, :digest_email).with(
        a_hash_including(params: { user: user })
      )
    end

    it 'creates digest when there are unread notifications' do
      unread_notification

      expect { call }.to have_enqueued_mail(DigestMailer, :digest_email).with(
        a_hash_including(params: { user: user })
      )
    end

    it 'creates digest when there are notifications and topics' do
      recently_resolved_topic
      unread_notification

      expect { call }.to have_enqueued_mail(DigestMailer, :digest_email).with(
        a_hash_including(params: { user: user })
      )
    end
  end
end
