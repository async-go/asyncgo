# frozen_string_literal: true

module Users
  class NotificationsController < ::Users::ApplicationController
    include Pundit

    def show
      authorize([:users, notification])

      if notification_group.update(read_at: Time.now.utc)
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
      authorize(user, policy_class: Users::NotificationPolicy)

      current_user.notifications.update(read_at: Time.now.utc)

      redirect_back fallback_location: root_path
    end

    private

    def notification
      @notification ||= Notification.find(params[:id])
    end

    def notification_group
      Notification.where(
        user: notification.user, actor: notification.actor,
        target: notification.target, action: notification.action
      )
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
