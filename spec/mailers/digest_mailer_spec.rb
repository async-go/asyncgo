# frozen_string_literal: true

RSpec.describe DigestMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user, :team) }
  let!(:notification) { FactoryBot.create(:notification, user: user) }

  describe '#digest_email' do
    subject(:digest_email) { described_class.with(user: user, notifications: [notification]).digest_email }

    it 'renders the headers' do
      expect(digest_email).to have_attributes(
        subject: 'Your AsyncGo Digest',
        from: ['notifications@asyncgo.com'],
        to: [user.email]
      )
    end

    it 'renders the body' do
      expect(digest_email.body.encoded).to include("Here's your AsyncGo Digest")
    end

    it 'contains the notification' do
      expect(digest_email.body.encoded).to include(notification.actor.email)
    end
  end
end
