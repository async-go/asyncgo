# frozen_string_literal: true

module Teams
  module Topics
    class CommentsController < Teams::Topics::ApplicationController
      include Pundit

      def edit
        @comment = comment
        authorize(@comment)
      end

      def create
        comment = topic.comments.build(create_params)
        authorize(comment)

        comment_flash = if update_comment(comment, create_params)
                          { success: 'Comment was successfully created.' }

                        else
                          { danger: comment.errors.full_messages.join(', ') }
                        end

        redirect_to team_topic_path(comment.topic.team, comment.topic), flash: comment_flash
      end

      def update
        @comment = comment
        authorize(@comment)

        if update_comment(@comment, comment_params)
          redirect_to team_topic_path(@comment.topic.team, @comment.topic),
                      flash: { success: 'Comment was successfully updated.' }
        else
          render :edit, status: :unprocessable_entity
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:body)
      end

      def create_params
        comment_params.merge(user: current_user)
      end

      def comment
        @comment ||= topic.comments.find(params[:comment_id] || params[:id])
      end

      def update_comment(comment, comment_params)
        CommentUpdater.new(current_user, comment, comment_params).call
      end
    end
  end
end
