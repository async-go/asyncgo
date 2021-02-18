# frozen_string_literal: true

module Teams
  class TopicsController < Teams::Topics::ApplicationController
    include Pagy::Backend
    include Pundit

    def index
      authorize(team, policy_class: TopicPolicy)
      @pagy_active_topics, @active_topics = pagy(
        team.topics.active.order('due_date DESC NULLS LAST'), page_param: 'active_page'
      )
      @pagy_closed_topics, @closed_topics = pagy(
        team.topics.closed.order('due_date DESC NULLS LAST'), page_param: 'closed_page'
      )
      @active_topics = preload_topics(@active_topics)
      @closed_topics = preload_topics(@closed_topics)
    end

    def show
      @topic = topic
      authorize(@topic)

      @pagy, @topic_comments = pagy(@topic.comments.order(:created_at))
      @topic_comments = @topic_comments.includes(:user, votes: :user)
    end

    def new
      @topic = team.topics.build
      authorize(@topic)
    end

    def edit
      @topic = topic
      authorize(@topic)
    end

    def create
      create_params = topic_params.merge(user: current_user)
      @topic = team.topics.build(create_params)
      authorize(@topic)

      if TopicUpdater.new(current_user, @topic, topic_params).call
        redirect_to team_topic_path(@topic.team, @topic),
                    flash: { success: 'Topic was successfully created.' }
      else
        render :new
      end
    end

    def update
      @topic = topic
      authorize(@topic)

      update_result = TopicUpdater.new(current_user, @topic, topic_params).call

      if update_result
        redirect_to team_topic_path(@topic.team, @topic),
                    flash: { success: 'Topic was successfully updated.' }
      else
        render :edit
      end
    end

    def subscribe
      authorize(topic)

      subscribe_flash = if update_user_subscription
                          { success: 'User subscription status was successfully changed.' }
                        else
                          { danger: 'There was an error while changing the subscription status.' }
                        end

      redirect_to team_topic_path(topic.team, topic), flash: subscribe_flash
    end

    private

    def topic_params
      params.require(:topic).permit(:title, :description, :outcome, :due_date, :status)
    end

    def update_user_subscription
      subscription = current_user.subscriptions.find_or_initialize_by(topic_id: topic.id)

      if params[:subscribed] == '1' && subscription.new_record?
        subscription.save
      elsif params[:subscribed] == '0' && subscription.persisted?
        subscription.destroy
      end
    end

    def preload_topics(scope)
      scope.includes(:user, :subscribed_users)
    end
  end
end
