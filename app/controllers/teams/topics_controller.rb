# frozen_string_literal: true

module Teams
  class TopicsController < Teams::Topics::ApplicationController
    include Pundit

    def index
      authorize(team, policy_class: Teams::TopicPolicy)
      @active_topics = team.topics.active
      @closed_topics = team.topics.closed
    end

    def show
      @topic = topic
      authorize([:teams, @topic])
    end

    def new
      @topic = team.topics.build
      authorize([:teams, @topic])
    end

    def edit
      @topic = topic
      authorize([:teams, @topic])
    end

    def create
      @topic = team.topics.build(topic_params)
      authorize([:teams, @topic])

      if TopicUpdater.new(current_user, @topic, topic_params).call
        redirect_to team_topic_path(@topic.team, @topic),
                    flash: { success: 'Topic was successfully created.' }
      else
        render :new
      end
    end

    def update
      @topic = topic
      authorize([:teams, @topic])

      update_result = TopicUpdater.new(current_user, @topic, topic_params).call

      if update_result
        redirect_to team_topic_path(@topic.team, @topic),
                    flash: { success: 'Topic was successfully updated.' }
      else
        render :edit
      end
    end

    def subscribe
      authorize([:teams, topic])

      subscribe_flash = if update_user_subscription
                          { success: 'User subscription status was successfully changed.' }
                        else
                          { danger: 'There was an error while changing the subscription status.' }
                        end

      redirect_to team_topic_path(topic.team, topic), flash: subscribe_flash
    end

    private

    def topic_params
      params.require(:topic).permit(:title, :description, :outcome, :due, :status, :user_id)
    end

    def update_user_subscription
      subscription = current_user.subscriptions.find_or_initialize_by(topic_id: topic.id)

      if params[:subscribed] == '1' && subscription.new_record?
        subscription.save
      elsif params[:subscribed] == '0' && subscription.persisted?
        subscription.destroy
      end
    end
  end
end
