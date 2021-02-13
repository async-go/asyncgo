# frozen_string_literal: true

module Teams
  module Topics
    class VotesController < Teams::Topics::ApplicationController
      include Pundit

      def create
        authorize(topic, policy_class: Teams::Topics::VotePolicy)

        vote_flash = if Vote.create(create_params).valid?
                       { success: 'Vote was successfully added.' }
                     else
                       { danger: 'There was an error while adding the vote.' }
                     end

        redirect_to team_topic_path(topic.team, topic), flash: vote_flash
      end

      def destroy
        vote = topic.votes.find(params[:id])
        authorize([:teams, :topics, vote])

        topic.votes.destroy(vote)
        redirect_to team_topic_path(topic.team, topic),
                    flash: { success: 'Vote was successfully removed.' }
      end

      private

      def create_params
        params.require(:vote).permit(:emoji).merge(user: current_user, votable: topic)
      end
    end
  end
end
