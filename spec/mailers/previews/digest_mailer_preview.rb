# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/digest_mailer
class DigestMailerPreview < ActionMailer::Preview
  def digest_email
    team = Team.new(name: 'sample team')
    user = User.new(id: 1, email: 'test@example.com', name: 'Bob Test', team: team)

    DigestMailer.with(user: user).digest_email
  end
end
