# frozen_string_literal: true

module Teams
  module Topics
    class CommentsController < Teams::Topics::ApplicationController
      include Pundit

      def edit
        @comment = comment
        authorize([:teams, :topics, @comment])
      end

      def create
        comment = topic.comments.build(comment_params)
        authorize([:teams, :topics, comment])

        comment_flash = if CommentUpdater.new(comment, comment_params).call
                          { success: 'Comment was successfully created.' }

                        else
                          { danger: comment.errors.full_messages.join(', ') }
                        end

        redirect_to team_topic_path(comment.topic.team, comment.topic), flash: comment_flash
      end

      def update
        @comment = comment
        authorize([:teams, :topics, @comment])

        if CommentUpdater.new(@comment, comment_params).call
          redirect_to team_topic_path(@comment.topic.team, @comment.topic),
                      flash: { success: 'Comment was successfully updated.' }
        else
          render :edit
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:body, :user_id)
      end

      def comment
        @comment ||= topic.comments.find(params[:comment_id] || params[:id])
      end
    end
  end
end
