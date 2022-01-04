# frozen_string_literal: true

RSpec.describe SupportMailer, type: :mailer do
  let(:user) { create(:user, :team) }
  let(:body) { 'Sample body contents' }

  describe '#support_email' do
    subject(:support_email) { described_class.with(user:, body:).support_email }

    it 'renders the headers' do
      expect(support_email).to have_attributes(
        subject: "Support request: #{user.team.name}",
        from: [user.email],
        to: ['support@asyncgo.com']
      )
    end

    it 'renders the body' do
      expect(support_email.body.encoded).to include(body)
    end

    it 'shows the team name' do
      expect(support_email.body.encoded).to include("Name: #{user.team.name}")
    end
  end
end
