# frozen_string_literal: true

module Teams
  class TopicsController < Teams::Topics::ApplicationController # rubocop:disable Metrics/ClassLength
    include Pagy::Backend

    DESCRIPTION_TEMPLATE = '## Decisions needed
Clearly describe the problem or improvement and what decision(s) need to be made.

## Why is it important
Explain why it is important now to have this discussion and make a decision.

## Background
Include any additional background details or context that would be helpful.'

    OUTCOME_TEMPLATE = '## Decisions made
- [ ] TBD

## Action items
- [ ] TBD

## Other important discussion notes
To be determined'

    def index
      authorize(team, policy_class: TopicPolicy)

      @team = team
      topics = filtered_topics(team.topics.where(is_archived: false).includes(:user, :subscribed_users, :labels))
      active_topics = topics.active.order(pinned: :desc).by_due_date
      resolved_topics = topics.resolved.order(pinned: :desc, updated_at: :desc)
      @pagy_active_topics, @active_topics = pagy(active_topics, page_param: 'active_page')
      @pagy_resolved_topics, @resolved_topics = pagy(resolved_topics, page_param: 'resolved_page')
    end

    def new
      @topic = team.topics.build(new_params)
      @topic.description = DESCRIPTION_TEMPLATE unless defined? new_params[:description]
      @topic.outcome = OUTCOME_TEMPLATE unless defined? new_params[:outcome]
      authorize(@topic)
    end

    def show
      @topic = topic
      authorize(@topic)

      current_user.clear_topic_notifications(@topic)

      comment_order = current_user.preferences.inverse_comment_order ? :desc : :asc

      @topic_comments = @topic.comments.where(is_archived: false)
                              .order(created_at: comment_order)
                              .includes(:user, topic: :team, votes: :user)
    end

    def edit
      @topic = topic
      authorize(@topic)
    end

    def archive
      @topic = topic
      authorize(@topic)
      @topic.update(is_archived: true)

      redirect_to root_path, flash: { success: 'Topic was successfully archived.' }
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
                       { success: "Topic status was successfully changed to #{target_topic.status}." }
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

    def new_params
      return if params[:context].blank?

      {
        description: <<~DESCRIPTION
          Created from: #{params[:context]}
          #{"#{params[:selection].gsub(/^/m, '> ')}\n" if params[:selection].present?}
        DESCRIPTION
      }
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
          redirect_to topic_path(target_topic), flash:
        end
      end
    end
  end
end
