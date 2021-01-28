# frozen_string_literal: true

RSpec.describe DigestMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user, :team) }
  let(:notification) { FactoryBot.create(:notification) }
  let(:mail) { described_class.with(user: user, notifications: [notification]).digest_email }

  describe '#digest_email' do
    it 'renders the headers' do
      expect(mail).to have_attributes(
        subject: 'Your AsyncGo Digest',
        to: [user.email],
        from: ['notifications@asyncgo.com']
      )
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include("Here's your AsyncGo Digest")
    end

    it 'contains the notification' do
      expect(mail.body.encoded).to include(notification.actor.email)
    end
  end
end
