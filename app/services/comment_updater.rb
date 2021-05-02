# frozen_string_literal: true

class CommentUpdater < ApplicationService
  def initialize(user, comment, update_params)
    super()

    @user = user
    @comment = comment
    @update_params = update_params
  end

  def call
    new_comment = @comment.new_record?
    @comment.update(@update_params).tap do |result|
      next unless result
      next unless new_comment

      notify_users!
      @comment.topic.subscriptions.create(user: @user)
    end
  end

  private

  def notify_users!
    subscriber_ids = @comment.topic.subscribed_users.pluck(:id)
    subscriber_ids.each do |subscriber_id|
      next if subscriber_id == @user.id

      @comment.notifications.create(actor: @user, user_id: subscriber_id, action: :created)
    end
  end
end
