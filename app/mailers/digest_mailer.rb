# frozen_string_literal: true

class DigestMailer < ApplicationMailer
  default from: 'notifications@asyncgo.com'

  def digest_email
    @user = params[:user]
    @notifications = params[:notifications]
    mail(to: @user.email, subject: 'Welcome to AsyncGo', notifications: @notifications)
  end
end
