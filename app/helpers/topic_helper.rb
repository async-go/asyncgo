# frozen_string_literal: true

module TopicHelper
  def printable_due_date(topic)
    return unless topic.due_date?

    if topic.active?
      if topic.due_date < Time.now.utc
        "#{distance_of_time_in_words(topic.due_date, Time.now.utc)} ago"
      else
        "#{distance_of_time_in_words(Time.now.utc, topic.due_date)} remaining"
      end
    else
      topic.due_date.strftime('%b %-d')
    end
  end
end
