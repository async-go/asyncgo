# frozen_string_literal: true

module Teams
  module Topics
    class VotesController < Teams::Topics::ApplicationController
      def create
        authorize(topic, policy_class: Teams::Topics::VotePolicy)

        vote_flash = if Vote.create(create_params).valid?
                       { success: 'Vote was successfully added.' }
                     else
                       { danger: 'There was an error while adding the vote.' }
                     end

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(topic, partial: 'teams/topics/topic', locals: { topic: topic })
          end
          format.html { redirect_to team_topic_path(topic.team, topic), flash: vote_flash }
        end
      end

      def destroy
        vote = topic.votes.find(params[:id])
        authorize([:teams, :topics, vote])

        topic.votes.destroy(vote)

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(topic, partial: 'teams/topics/topic', locals: { topic: topic })
          end
          format.html do
            redirect_to team_topic_path(topic.team, topic),
                        flash: { success: 'Vote was successfully removed.' }
          end
        end
      end

      private

      def create_params
        params.require(:vote).permit(:emoji).merge(user: current_user, votable: topic)
      end
    end
  end
end
