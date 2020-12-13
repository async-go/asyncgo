# frozen_string_literal: true

module Topics
  class CommentsController < ApplicationController
    def new
      @topic = Topic.find(params[:topic_id])
      @comment = Comment.new
    end

    def create
      @comment = Topic.find(params[:topic_id]).comments.build(comment_params.merge(user: User.first))

      @comment.save

      redirect_to topic_path(@comment.topic)
    end

    private

    def comment_params
      params.permit(:body)
    end
  end
end
