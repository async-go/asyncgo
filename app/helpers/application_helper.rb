# frozen_string_literal: true

module ApplicationHelper
  def printable_due_date(topic)
    return if topic.due_date.blank? || !topic.active?

    if topic.days_remaining.negative?
      "Overdue by #{pluralize(topic.days_remaining.abs, 'day')}"
    else
      "#{pluralize(topic.days_remaining, 'day')} remaining"
    end
  end
end
