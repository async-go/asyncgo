# frozen_string_literal: true

class SupportMailerPreview < ActionMailer::Preview
  def support_email
    team = Team.new(id: 1, name: 'example team')
    user = User.new(email: 'test@example.com', team: team)
    body = 'Sample body'

    SupportMailer.with(user: user, body: body).support_email
  end
end
