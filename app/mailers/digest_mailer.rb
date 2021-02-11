# frozen_string_literal: true

class DigestMailer < ApplicationMailer
  helper ApplicationHelper
  default from: 'notifications@asyncgo.com'

  def digest_email
    @notifications = params[:notifications]
    @user = params[:user]
    mail(to: @user.email, subject: 'Your AsyncGo Digest', notifications: @notifications)
  end
end
