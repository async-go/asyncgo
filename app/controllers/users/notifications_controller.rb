# frozen_string_literal: true

module Users
  class NotificationsController < ApplicationController
    include Pundit

    def show
      authorize([:users, notification])

      redirect_target = case notification.target_type
                        when 'Comment'
                          notification.target.topic
                        when 'Topic'
                          notification.target
                        end

      redirect_to team_topic_path(redirect_target.team, redirect_target)
    end

    private

    def notification
      @notification ||= Notification.find(params[:id])
    end
  end
end
