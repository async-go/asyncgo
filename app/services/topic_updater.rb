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

      users, action = new_topic ? [@topic.team.users, :created] : [@topic.subscribed_users, :updated]
      notify_users!(users, action)
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

  def notify_users!(users, action)
    users.pluck(:id).each do |target_user_id|
      next if target_user_id == @user.id

      @topic.notifications.create(actor: @user, user_id: target_user_id, action: action)
    end
  end
end
