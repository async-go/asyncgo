# frozen_string_literal: true

class DigestMailer < ApplicationMailer
  helper ApplicationHelper
  default from: 'notifications@asyncgo.com'

  def digest_email
    @notifications = params[:notifications]
    mail(to: params[:user].email, subject: 'Your AsyncGo Digest', notifications: @notifications)
  end
end
