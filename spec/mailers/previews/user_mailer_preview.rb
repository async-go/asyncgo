# frozen_string_literal: true

class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    user = User.new(email: 'test@example.com')
    user.team = Team.new(name: 'example team')

    UserMailer.with(user: user).welcome_email
  end
end
