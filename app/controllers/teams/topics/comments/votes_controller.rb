# frozen_string_literal: true

module Teams
  module Topics
    module Comments
      class VotesController < Teams::Topics::Comments::ApplicationController
        def create # rubocop:disable Metrics/MethodLength
          target_comment = comment
          authorize(target_comment, policy_class: Teams::Topics::Comments::VotePolicy)

          success = Vote.create(create_params).valid?

          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: turbo_stream.replace(target_comment, partial: 'teams/topics/comments/comment',
                                                                        locals: { comment: target_comment })
            end
            format.html do
              vote_flash = if success
                             { success: 'Vote was successfully added.' }
                           else
                             { danger: 'There was an error while adding the vote.' }
                           end

              redirect_to topic_path(target_comment), flash: vote_flash
            end
          end
        end

        def destroy # rubocop:disable Metrics/MethodLength
          target_comment = comment
          vote = target_comment.votes.find(params[:id])
          authorize([:teams, :topics, :comments, vote])

          vote.destroy
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: turbo_stream.replace(target_comment, partial: 'teams/topics/comments/comment',
                                                                        locals: { comment: target_comment })
            end
            format.html { redirect_to topic_path(target_comment), flash: { success: 'Vote was successfully removed.' } }
          end
        end

        private

        def create_params
          params.require(:vote).permit(:emoji).merge(user: current_user, votable: comment)
        end

        def topic_path(comment)
          team_topic_path(comment.topic.team, comment.topic)
        end
      end
    end
  end
end
