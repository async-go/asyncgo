# frozen_string_literal: true

module Teams
  module TopicsHelper
    include ::Pagy::Frontend

    def user_subscribed?(topic)
      topic.subscribed_users.include?(current_user)
    end

    def topic_due_date_span(topic)
      alert_style = topic_overdue?(topic) ? 'rounded p-1 bg-info text-white' : nil

      tag.span(class: alert_style) do
        topic_due_date_text(topic)
      end
    end

    def topic_has_notification?(notifications, topic)
      # It's cheaper to check this in memory than it is to query the
      # database for every single topic. We expect an user to have a
      # couple dozen notifications at the most.
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
        "Due #{pluralize((topic.due_date..Time.now.utc).count - 1, 'day')} ago"
      elsif ((Time.now.utc.to_date..topic.due_date).count - 1).zero?
        'Due today'
      elsif (Time.now.utc.to_date..topic.due_date).count - 1 == 1
        'Due tomorrow'
      else
        "Due in #{pluralize((Time.now.utc.to_date..topic.due_date).count - 1, 'day')}"
      end
    end

    def topic_overdue?(topic)
      return false unless topic.due_date?
      return false unless topic.active?

      topic.due_date.end_of_day < Time.now.utc
    end
  end
end
