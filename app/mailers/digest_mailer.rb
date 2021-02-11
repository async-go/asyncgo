# frozen_string_literal: true

class DigestMailer < ApplicationMailer
  helper ApplicationHelper
  default from: 'notifications@asyncgo.com'

  def digest_email
    @notifications = params[:notifications].uniq do |notification|
      notification.values_at(:target_id, :actor_id, :user_id, :action)
    end

    @user = params[:user]

    mail(to: @user.email, subject: 'Your AsyncGo Digest', notifications: @notifications)
  end
end
