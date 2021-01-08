# frozen_string_literal: true

module Teams
  class TopicsController < Teams::Topics::ApplicationController
    include Pundit

    def index
      authorize(team, policy_class: Teams::TopicPolicy)
      @active_topics = team.topics.where(decision: nil)
      @closed_topics = team.topics.where.not(decision: nil)
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

      if @topic.update(topic_params)
        redirect_to team_topic_path(@topic.team, @topic),
                    flash: { success: 'Topic was successfully updated.' }
      else
        render :edit
      end
    end

    private

    def topic_params
      params.require(:topic).permit(:title, :description, :decision, :user_id).dup.tap do |original_params|
        original_params[:decision] = nil if original_params[:decision] && original_params[:decision].empty?

        if original_params[:description].present?
          original_params[:description_html] =
            parse_markdown(original_params[:description])
        end

        if original_params[:decision].present?
          original_params[:decision_html] =
            parse_markdown(original_params[:decision])
        end
      end
    end
  end
end
