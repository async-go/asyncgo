# frozen_string_literal: true

module Teams
  module Topics
    class CommentsController < Teams::Topics::ApplicationController
      include Pundit

      def new
        @comment = topic.comments.build
        authorize([:teams, :topics, @comment])
      end

      def edit
        @comment = comment
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

      def update
        @comment = comment
        authorize([:teams, :topics, @comment])

        if @comment.update(comment_params)
          redirect_to team_topic_path(@comment.topic.team, @comment.topic),
                      flash: { success: 'Comment was successfully updated.' }
        else
          render :edit
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:body, :user_id).dup.tap do |original_params|
          original_params[:body_html] = parse_markdown(original_params[:body]) if original_params[:body]
        end
      end

      def comment
        @comment ||= topic.comments.find(params[:comment_id] || params[:id])
      end
    end
  end
end
