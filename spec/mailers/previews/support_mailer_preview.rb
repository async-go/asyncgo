# frozen_string_literal: true

class SupportMailerPreview < ActionMailer::Preview
  def support_email
    user = User.new(email: 'test@example.com')
    user.team = Team.new(name: 'example team')
    body = 'Sample body'

    UserMailer.with(user: user, body: body).welcome_email
  end
end
