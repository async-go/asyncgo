# frozen_string_literal: true

class DigestMailer < ApplicationMailer
  helper ApplicationHelper
  default from: 'notifications@asyncgo.com'

  after_action :prevent_delivery_if_no_notifications

  def digest_email
    @notifications = params[:user].notifications.where(read_at: nil)

    mail(to: params[:user].email, subject: 'Your AsyncGo Digest',
         notifications: @notifications)
  end

  private

  def prevent_delivery_if_no_notifications
    if @notifications.count == 0
      mail.perform_deliveries = false
    end
  end  
end
