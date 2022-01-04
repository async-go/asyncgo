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
    @topic.update(processed_params).tap do |result|
      next unless result

      notify_users!(notification_users(new_topic), notification_action(new_topic, processed_params))
      next unless new_topic

      @topic.subscriptions.create(user: @user)
    end
  end

  private

  def processed_params
    @update_params.tap do |params|
      processed_params = process_description(params)
      process_outcome(processed_params)
    end
  end

  def process_description(original_params)
    original_params.tap do |params|
      next if params[:description].nil?

      params[:description_html] = MarkdownParser.new(@user, params[:description], @topic).call
    end
  end

  def process_outcome(original_params)
    original_params.tap do |params|
      next if params[:outcome].nil?

      if params[:outcome].empty?
        params[:outcome] = nil
        params[:outcome_html] = nil
      elsif params[:outcome].present?
        params[:outcome_html] = MarkdownParser.new(@user, params[:outcome], @topic).call
      end
    end
  end

  def notification_update_action(params)
    case params[:status]
    when 'resolved'
      :resolved
    when 'active'
      :reopened
    else
      :updated
    end
  end

  def notification_users(new_topic)
    new_topic ? @topic.team.users : @topic.subscribed_users
  end

  def notification_action(new_topic, params)
    new_topic ? :created : notification_update_action(params)
  end

  def notify_users!(users, action)
    users.pluck(:id).each do |target_user_id|
      next if target_user_id == @user.id

      @topic.notifications.create(actor: @user, user_id: target_user_id, action:)
    end
  end
end
