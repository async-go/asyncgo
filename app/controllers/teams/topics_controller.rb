# frozen_string_literal: true

module Teams
  class TopicsController < Teams::Topics::ApplicationController
    include Pundit

    def index
      authorize(team, policy_class: Teams::TopicPolicy)
      @topics = team.topics
    end

    def show
      @topic = topic
      authorize([:teams, @topic])
    end

    def new
      @topic = team.topics.build
      authorize([:teams, @topic])
    end

    def create
      @topic = team.topics.build(topic_params)
      authorize([:teams, @topic])

      if @topic.save
        redirect_to team_topic_path(@topic.team, @topic),
                    flash: { success: 'Topic was successfully created.' }
      else
        render :new
      end
    end

    private

    def topic_params
      params.require(:topic).permit(:title, :description, :user_id)
    end
  end
end
