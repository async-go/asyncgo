# frozen_string_literal: true

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user, :team) }
  let(:mail) { described_class.with(user: user).welcome_email }

  describe '#welcome_email' do
    it 'renders the headers' do
      expect(mail).to have_attributes(
        subject: 'Welcome to AsyncGo',
        from: ['notifications@asyncgo.com'],
        to: [user.email]
      )
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('You have been invited')
    end
  end
end
