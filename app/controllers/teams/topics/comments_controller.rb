# frozen_string_literal: true

module Teams
  module Topics
    class CommentsController < Teams::Topics::ApplicationController
      def new
        @comment = topic.comments.build
        Pundit.authorize(current_user, @comment, :new?, policy_class: Teams::Topics::CommentPolicy)
      end

      def create
        @comment = topic.comments.build(comment_params)
        Pundit.authorize(current_user, @comment, :create?, policy_class: Teams::Topics::CommentPolicy)

        if @comment.save
          redirect_to team_topic_path(@comment.topic.team, @comment.topic),
                      flash: { success: 'Comment was successfully created.' }
        else
          render :new
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:body, :user_id)
      end
    end
  end
end
