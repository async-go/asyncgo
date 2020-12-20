# frozen_string_literal: true

module Teams
  class TopicsController < Teams::Topics::ApplicationController
    def index
      @topics = team.topics
      Pundit.authorize(current_user, team, :index?, policy_class: Teams::TopicPolicy)
    end

    def show
      @topic = topic
      Pundit.authorize(current_user, @topic, :show?, policy_class: Teams::TopicPolicy)
    end

    def new
      @topic = team.topics.build
      Pundit.authorize(current_user, @topic, :new?, policy_class: Teams::TopicPolicy)
    end

    def create
      @topic = team.topics.build(topic_params)
      Pundit.authorize(current_user, @topic, :create?, policy_class: Teams::TopicPolicy)

      if @topic.save
        redirect_to team_topic_path(@topic.team, @topic),
                    flash: { success: 'Topic was successfully created.' }
      else
        render :new
      end
    end

    private

    def topic_params
      params.require(:topic).permit(:title, :user_id)
    end
  end
end
