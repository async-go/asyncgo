# frozen_string_literal: true

module TopicHelper
  def printable_due_date(topic)
    return 'No due date' unless topic.due_date?

    if topic.active?
      if topic.due_date < Time.now.utc
        "Due #{distance_of_time_in_words(topic.due_date, Time.now.utc)} ago"
      else
        "Due in #{distance_of_time_in_words(Time.now.utc, topic.due_date)}"
      end
    else
      "Due #{topic.due_date.strftime('%b %-d')}"
    end
  end
end
