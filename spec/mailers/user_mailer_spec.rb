# frozen_string_literal: true

RSpec.describe UserMailer, type: :mailer do
  let(:team) { FactoryBot.create(:team) }
  let(:user) { FactoryBot.create(:user, team: team) }
  let(:mail) { described_class.with(user: user, team: team).welcome_email }

  describe '#welcome_email' do
    it 'renders the headers' do
      expect(mail).to have_attributes(
        subject: 'Welcome to AsyncGo',
        to: [user.email],
        from: ['notifications@asyncgo.com']
      )
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('Welcome to AsyncGo.com')
    end
  end
end
