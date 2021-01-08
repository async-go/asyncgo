# frozen_string_literal: true

class TopicUpdater < ApplicationService
  attr_reader :topic, :update_params

  def initialize(topic, update_params)
    super()

    @topic = topic
    @update_params = update_params
  end

  def call
    @topic.update(process_params(update_params))
  end

  private

  def process_params(original_params)
    original_params.tap do |params|
      processed_params = process_description(params)
      process_decision(processed_params)
    end
  end

  def process_description(original_params)
    original_params.tap do |params|
      return params if params[:description].nil?

      params[:description_html] = parse_markdown(params[:description])
    end
  end

  def process_decision(original_params)
    original_params.tap do |params|
      return params if params[:decision].nil?

      if params[:decision].empty?
        params[:decision] = nil
        params[:decision_html] = nil
      elsif params[:decision].present?
        params[:decision_html] = parse_markdown(params[:decision])
      end
    end
  end
end
