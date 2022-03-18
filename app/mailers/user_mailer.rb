# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'notifications@asyncgo.com'

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: I18n.t(:welcome_to_asyncgo))
  end
end
