# frozen_string_literal: true

class SupportMailerPreview < ActionMailer::Preview
  def support_email
    team = Team.new(id: 1, name: 'example team')
    user = User.new(id: 1, email: 'test@example.com', team:)
    body = 'Sample body'

    SupportMailer.with(user:, body:).support_email
  end
end
