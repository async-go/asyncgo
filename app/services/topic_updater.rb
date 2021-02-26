# frozen_string_literal: true

class TopicUpdater < ApplicationService
  def initialize(user, topic, update_params)
    super()

    @user = user
    @topic = topic
    @update_params = update_params
  end

  def call
    new_topic = @topic.new_record?
    @topic.update(@update_params).tap do |result|
      next unless result

      users, action = new_topic ? [@topic.team.users, :created] : [@topic.subscribed_users, :updated]
      notify_users!(users, action)
      next unless new_topic

      @topic.subscriptions.create(user: @user)
    end
  end

  private

  def notify_users!(users, action)
    users.pluck(:id).each do |target_user_id|
      next if target_user_id == @user.id

      @topic.notifications.create(actor: @user, user_id: target_user_id, action: action)
    end
  end
end
