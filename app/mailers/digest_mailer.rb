# frozen_string_literal: true

class DigestMailer < ApplicationMailer
  helper ApplicationHelper
  default from: 'notifications@asyncgo.com'

  def digest_email
    @notifications = Notification.where(user: params[:user], read_at: nil)
    return unless @notifications

    mail(to: params[:user].email, subject: 'Your AsyncGo Digest', notifications: @notifications)
  end
end
