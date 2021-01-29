# frozen_string_literal: true

module Users
  class NotificationsController < ApplicationController
    include Pundit

    def show
      authorize([:users, notification])

      if notification.update(read_at: Time.now.utc)
        redirect_object = redirect_target(notification)
        redirect_path = team_topic_path(redirect_object.team, redirect_object)
        redirect_flash = nil
      else
        redirect_path = root_path
        redirect_flash = { danger: 'Notification could not be marked as read.' }
      end

      redirect_to redirect_path, flash: redirect_flash
    end

    def clear
      authorize([:users, Notification])

      current_user.notifications.update(read_at: Time.now.utc)

      redirect_back fallback_location: root_path
    end

    private

    def notification
      @notification ||= Notification.find(params[:id])
    end

    def redirect_target(notification)
      case notification.target_type
      when 'Comment'
        notification.target.topic
      when 'Topic'
        notification.target
      end
    end
  end
end
