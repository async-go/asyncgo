# frozen_string_literal: true

module Teams
  module TopicsHelper
    include ::Pagy::Frontend

    def user_subscribed?(topic)
      topic.subscribed_users.include?(current_user)
    end

    def topic_due_date_span(topic)
      background_color = topic_overdue?(topic) ? 'warning' : 'success'
      classes = "rounded p-1 text-white bg-#{background_color}"

      tag.span(class: classes) do
        topic_due_date_text(topic)
      end
    end

    def topic_has_notification?(notifications, topic)
      notifications.any? do |notification|
        notification.target == topic ||
          (notification.target_type == 'Comment' && notification.target.topic_id == topic.id)
      end
    end

    def string_checksum(value)
      Digest::MD5.hexdigest(value.to_s)
    end

    private

    def topic_due_date_text(topic)
      return 'No due date' unless topic.due_date?

      if topic.active?
        active_topic_due_date_text(topic)
      else
        "Due #{topic.due_date.strftime('%b %-d')}"
      end
    end

    def active_topic_due_date_text(topic)
      if topic_overdue?(topic)
        "Due #{distance_of_time_in_words(topic.due_date.end_of_day, Time.now.utc)} ago"
      else
        "Due in #{distance_of_time_in_words(Time.now.utc, topic.due_date.end_of_day)}"
      end
    end

    def topic_overdue?(topic)
      return false unless topic.due_date?

      topic.due_date.end_of_day < Time.now.utc
    end
  end
end
