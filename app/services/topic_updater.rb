# frozen_string_literal: true

class TopicUpdater < ApplicationService
  attr_reader :topic, :update_params

  def initialize(user, topic, update_params)
    super()

    @user = user
    @topic = topic
    @update_params = update_params
  end

  def call
    new_topic = @topic.new_record?
    @topic.update(process_params(update_params)).tap do |result|
      next unless result

      if new_topic
        @topic.subscriptions.create(user: @user)
        notify_users!(@topic.team.users, :created)
      else
        notify_users!(@topic.subscribed_users, :updated)
      end
    end
  end

  private

  def process_params(original_params)
    original_params.tap do |params|
      processed_params = process_description(params)
      process_outcome(processed_params)
    end
  end

  def process_description(original_params)
    original_params.tap do |params|
      return params if params[:description].nil?

      params[:description_html] = parse_markdown(params[:description])
    end
  end

  def process_outcome(original_params)
    original_params.tap do |params|
      return params if params[:outcome].nil?

      if params[:outcome].empty?
        params[:outcome] = nil
        params[:outcome_html] = nil
      elsif params[:outcome].present?
        params[:outcome_html] = parse_markdown(params[:outcome])
      end
    end
  end

  def notify_users!(users, action)
    users.pluck(:id).each do |target_user_id|
      next if target_user_id == @user.id

      @topic.notifications.create(actor: @user, user_id: target_user_id, action: action)
    end
  end
end
