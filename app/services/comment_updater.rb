# frozen_string_literal: true

class CommentUpdater < ApplicationService
  attr_reader :comment, :update_params

  def initialize(user, comment, update_params)
    super()

    @user = user
    @comment = comment
    @update_params = update_params
  end

  def call
    new_comment = @comment.new_record?
    @comment.update(process_params(update_params)).tap do |result|
      next unless result && new_comment

      @comment.topic.subscriptions.create(user: @user)
    end
  end

  private

  def process_params(original_params)
    original_params.tap do |params|
      process_body(params)
    end
  end

  def process_body(original_params)
    original_params.tap do |params|
      break if params[:body].nil?

      params[:body_html] = parse_markdown(params[:body])
    end
  end
end
