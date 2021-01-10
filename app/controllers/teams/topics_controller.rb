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

      if TopicUpdater.new(@topic, topic_params).call
        redirect_to team_topic_path(@topic.team, @topic),
                    flash: { success: 'Topic was successfully created.' }
      else
        render :new
      end
    end

    def update
      @topic = topic
      authorize([:teams, @topic])

      update_result = TopicUpdater.new(@topic, topic_params).call

      if update_result
        redirect_to team_topic_path(@topic.team, @topic),
                    flash: { success: 'Topic was successfully updated.' }
      else
        render :edit
      end
    end

    private

    def topic_params
      params.require(:topic).permit(:title, :description, :decision, :user_id)
    end
  end
end
