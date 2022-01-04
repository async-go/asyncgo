# frozen_string_literal: true

module Teams
  module Topics
    class VotesController < Teams::Topics::ApplicationController
      def create # rubocop:disable Metrics/MethodLength
        authorize(topic, policy_class: Teams::Topics::VotePolicy)

        success = Vote.create(create_params).valid?

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(topic, partial: 'teams/topics/topic', locals: { topic: })
          end
          format.html do
            vote_flash = if success
                           { success: 'Vote was successfully added.' }
                         else
                           { danger: 'There was an error while adding the vote.' }
                         end

            redirect_to topic_path(topic), flash: vote_flash
          end
        end
      end

      def destroy # rubocop:disable Metrics/MethodLength
        target_topic = topic
        vote = target_topic.votes.find(params[:id])
        authorize([:teams, :topics, vote])

        vote.destroy
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(target_topic, partial: 'teams/topics/topic',
                                                                    locals: { topic: target_topic })
          end
          format.html { redirect_to topic_path(target_topic), flash: { success: 'Vote was successfully removed.' } }
        end
      end

      private

      def create_params
        params.require(:vote).permit(:emoji).merge(user: current_user, votable: topic)
      end

      def topic_path(topic)
        team_topic_path(topic.team, topic)
      end
    end
  end
end
