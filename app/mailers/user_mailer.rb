# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'notifications@asyncgo.com'

  def welcome_email
    @user = params[:user]
    @team = params[:team]
    mail(to: @user.email, subject: 'Welcome to AsyncGo')
  end
end
