# frozen_string_literal: true

class SupportMailer < ApplicationMailer
  default to: 'support@asyncgo.com'

  def support_email
    @user = params[:user]
    @body = params[:body]
    mail(from: @user.email, subject: "Support request: #{@user.team.name}")
  end
end
