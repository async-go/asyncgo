# frozen_string_literal: true

module Teams
  module Topics
    class CommentsController < Teams::Topics::ApplicationController
      include Pundit

      def new
        @comment = topic.comments.build
        authorize([:teams, :topics, @comment])
      end

      def create
        @comment = topic.comments.build(comment_params)
        authorize([:teams, :topics, @comment])

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
