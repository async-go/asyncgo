# frozen_string_literal: true

module Teams
  class TopicsController < Teams::Topics::ApplicationController # rubocop:disable Metrics/ClassLength
    include Pagy::Backend

    def index
      authorize(team, policy_class: TopicPolicy)

      @team = team
      team_topics = team.topics.order(pinned: :desc)
                        .by_due_date.includes(:user, :subscribed_users, :labels)
      @pagy_active_topics, @active_topics = pagy(
        filtered_topics(team_topics.active), page_param: 'active_page'
      )
      @pagy_closed_topics, @closed_topics = pagy(
        filtered_topics(team_topics.closed), page_param: 'closed_page'
      )
    end

    def new
      @topic = team.topics.build
      authorize(@topic)
    end

    def show
      @topic = topic
      authorize(@topic)

      @pagy, @topic_comments = pagy(
        @topic.comments.order(created_at: :asc)
        .includes(:user, topic: :team, votes: :user)
      )
    end

    def edit
      @topic = topic
      authorize(@topic)
    end

    def create
      @topic = team.topics.build
      authorize(@topic)

      if update_topic(@topic, create_params)
        redirect_to topic_path(@topic), flash: { success: 'Topic was successfully created.' }
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update # rubocop:disable Metrics/MethodLength
      @topic = topic
      authorize(@topic)

      if update_topic(@topic, topic_params)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(@topic, partial: 'teams/topics/topic', locals: { topic: @topic })
          end
          format.html { redirect_to topic_path(@topic), flash: { success: 'Topic was successfully updated.' } }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def toggle
      target_topic = topic
      authorize(target_topic)

      toggle_flash = if update_topic(target_topic, topic_params)
                       { success: 'Topic status was successfully changed.' }
                     else
                       { danger: 'Topic status could not be changed.' }
                     end

      redirect_to topic_path(target_topic), flash: toggle_flash
    end

    def subscribe
      target_topic = topic
      authorize(target_topic)

      render_turbo_or_html(
        target_topic,
        update_user_subscription(target_topic),
        'pinned / unpinned'
      )
    end

    def pin
      target_topic = topic
      authorize(target_topic)

      render_turbo_or_html(
        target_topic,
        update_topic(target_topic, topic_params),
        'pinned / unpinned'
      )
    end

    private

    def topic_params
      params.require(:topic).permit(
        :title, :description, :outcome, :due_date, :status,
        :description_checksum, :outcome_checksum, :pinned,
        :label_list
      )
    end

    def create_params
      topic_params.merge(user: current_user)
    end

    def update_user_subscription(topic)
      subscription = current_user.subscriptions.find_or_initialize_by(topic_id: topic.id)

      if params[:subscribed] == '1' && subscription.new_record?
        subscription.save
      elsif params[:subscribed] == '0' && subscription.persisted?
        subscription.destroy
      end
    end

    def filtered_topics(scope)
      return scope if params[:labels].blank?

      scope.tagged_with(params[:labels])
    end

    def preload_topics(scope)
      scope.includes(:user, :subscribed_users, :labels)
    end

    def update_topic(topic, topic_params)
      TopicUpdater.new(current_user, topic, topic_params).call
    end

    def topic_path(topic)
      team_topic_path(topic.team, topic)
    end

    def render_turbo_or_html(target_topic, success, flash_verb) # rubocop:disable Metrics/MethodLength
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(target_topic, partial: 'teams/topics/topic',
                                                                  locals: { topic: target_topic })
        end

        format.html do
          flash = if success
                    { success: "Topic was successfully #{flash_verb}." }
                  else
                    { danger: "Topic could not be #{flash_verb}." }
                  end
          redirect_to topic_path(target_topic), flash: flash
        end
      end
    end
  end
end
