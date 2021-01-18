# frozen_string_literal: true

RSpec.describe SupportMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user, :team) }
  let(:body) { 'Sample body contents' }
  let(:mail) { described_class.with(user: user, body: body).support_email }

  describe '#welcome_email' do
    it 'renders the headers' do
      expect(mail).to have_attributes(
        subject: "Support request: #{user.team.name}",
        from: [user.email],
        to: ['support@asyncgo.com']
      )
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include(body)
    end

    it 'shows the team name' do
      expect(mail.body.encoded).to include("Team Name: #{user.team.name}")
    end

    it 'shows the team id' do
      expect(mail.body.encoded).to include("Team ID: #{user.team.id}")
    end

    it 'shows the sender email' do
      expect(mail.body.encoded).to include("From: #{user.email}")
    end
  end
end
