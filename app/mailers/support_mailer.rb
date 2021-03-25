# frozen_string_literal: true

class SupportMailer < ApplicationMailer
  default to: 'support@asyncgo.com'

  def support_email
    @user = params[:user]
    @body = params[:body]
    mail(
      subject: "Support request: #{@user.team.name}",
      from: @user.email,
      reply_to: @user.email
    )
  end
end
