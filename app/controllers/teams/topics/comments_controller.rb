# frozen_string_literal: true

module Teams
  module Topics
    class CommentsController < Teams::Topics::ApplicationController
      include Pagy::Backend

      def new
        @comment = topic.comments.build
        authorize(@comment)
      end

      def edit
        @comment = comment
        authorize(@comment)
      end

      def create # rubocop:disable Metrics/MethodLength
        @comment = topic.comments.build
        authorize(@comment)

        if update_comment(@comment, create_params)
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: turbo_stream.action(
                turbo_stream_action, :comments,
                partial: 'teams/topics/comments/comment',
                locals: { comment: @comment }
              )
            end
            format.html do
              redirect_to topic_path(@comment)
            end
          end
        else
          render :new, status: :unprocessable_entity
        end
      end

      def update # rubocop:disable Metrics/MethodLength
        @comment = comment
        authorize(@comment)

        if update_comment(@comment, comment_params)
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: turbo_stream.replace(@comment, partial: 'teams/topics/comments/comment',
                                                                  locals: { comment: @comment })
            end
            format.html do
              redirect_to topic_path(@comment), flash: { success: 'Comment was successfully updated.' }
            end
          end
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

      def turbo_stream_action
        if current_user.preference.inverse_comment_order?
          :prepend
        else
          :append
        end
      end

      def update_comment(comment, comment_params)
        CommentUpdater.new(current_user, comment, comment_params).call
      end

      def topic_path(comment)
        team_topic_path(comment.topic.team, comment.topic)
      end
    end
  end
end
