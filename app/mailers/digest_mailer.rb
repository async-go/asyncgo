# frozen_string_literal: true

class DigestMailer < ApplicationMailer
  helper ApplicationHelper
  default from: 'notifications@asyncgo.com'

  after_action :prevent_delivery_if_no_notifications

  def digest_email
    @notifications = params[:notifications]
    mail(to: params[:user].email, subject: 'Your AsyncGo Digest', notifications: @notifications)
  end

  private

  def prevent_delivery_if_no_notifications
    mail.perform_deliveries = false if @notifications.count.zero?
  end
end
