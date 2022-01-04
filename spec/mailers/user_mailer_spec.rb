# frozen_string_literal: true

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user, :team) }

  describe '#welcome_email' do
    subject(:welcome_email) { described_class.with(user:).welcome_email }

    it 'renders the headers' do
      expect(welcome_email).to have_attributes(
        subject: 'Welcome to AsyncGo',
        from: ['notifications@asyncgo.com'],
        to: [user.email]
      )
    end

    it 'renders the body' do
      expect(welcome_email.body.encoded).to include('You have been invited')
    end
  end
end
