# frozen_string_literal: true

module Topics
  class CommentsController < ApplicationController
    def new
      @topic = Topic.find(params[:topic_id])
      @comment = Comment.new
    end

    def create
      @topic = Topic.find(params[:topic_id])
      @comment = @topic.comments.build(comment_params.merge(user: User.first))

      if @comment.save
        redirect_to topic_path(@comment.topic),
                    flash: { success: 'Comment was successfully created.' }
      else
        render :new
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:body)
    end
  end
end
