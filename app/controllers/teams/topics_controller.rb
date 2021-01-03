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

    def edit
      @topic = topic
      authorize([:teams, @topic])
    end

    def create
      @topic = team.topics.build(create_params)
      authorize([:teams, @topic])

      if @topic.save
        redirect_to team_topic_path(@topic.team, @topic),
                    flash: { success: 'Topic was successfully created.' }
      else
        render :new
      end
    end

    def update
      @topic = topic
      authorize([:teams, @topic])

      if @topic.update(update_params)
        redirect_to team_topic_path(@topic.team, @topic),
                    flash: { success: 'Topic was successfully updated.' }
      else
        render :show
      end
    end

    private

    def create_params
      params.require(:topic).permit(:title, :description, :user_id)
    end

    def update_params
      params.require(:topic).permit(:title, :description, :decision).dup.tap do |original_params|
        original_params[:decision] = nil if original_params[:decision] && original_params[:decision].empty?
      end
    end
  end
end
