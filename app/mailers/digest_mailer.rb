# frozen_string_literal: true

class DigestMailer < ApplicationMailer
  helper ApplicationHelper
  default from: 'notifications@asyncgo.com'

  def digest_email
    @user = params[:user]
    @notifications = params[:notifications]
    mail(to: @user.email, subject: 'Your AsyncGo Digest', notifications: @notifications)
  end
end
