# frozen_string_literal: true

module Teams
  module TopicsHelper
    include ::Pagy::Frontend

    def user_subscribed?(topic)
      topic.subscribed_users.include?(current_user)
    end

    def printable_due_date(topic)
      return 'No due date' unless topic.due_date?

      if topic.active?
        active_topic_due_date(topic)
      else
        "Due #{topic.due_date.strftime('%b %-d')}"
      end
    end

    def topic_has_notification?(notifications, topic)
      notifications.exists?(target: topic)
    end

    def emoji_group_text(emoji_name, count)
      "#{Emoji.find_by_alias(emoji_name).raw} #{count}" # rubocop:disable Rails/DynamicFindBy
    end

    def all_votes_in_topic
      current_user.votes.where(votable: topic.comments)
    end

    private

    def active_topic_due_date(topic)
      if topic.due_date.end_of_day < Time.now.utc
        "Due #{distance_of_time_in_words(topic.due_date.end_of_day, Time.now.utc)} ago"
      else
        "Due in #{distance_of_time_in_words(Time.now.utc, topic.due_date.end_of_day)}"
      end
    end
  end
end
