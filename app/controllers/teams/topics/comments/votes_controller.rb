# frozen_string_literal: true

module Teams
  module Topics
    module Comments
      class VotesController < Teams::Topics::Comments::ApplicationController
        def create
          authorize(comment, policy_class: Teams::Topics::Comments::VotePolicy)

          vote_flash = if Vote.create(create_params).valid?
                         { success: 'Vote was successfully added.' }
                       else
                         { danger: 'There was an error while adding the vote.' }
                       end

          redirect_to team_topic_comments_path(comment.topic.team, comment.topic), flash: vote_flash
        end

        def destroy
          vote = comment.votes.find(params[:id])
          authorize([:teams, :topics, :comments, vote])

          comment.votes.destroy(vote)
          redirect_to team_topic_comments_path(comment.topic.team, comment.topic),
                      flash: { success: 'Vote was successfully removed.' }
        end

        private

        def create_params
          params.require(:vote).permit(:emoji).merge(user: current_user, votable: comment)
        end
      end
    end
  end
end
