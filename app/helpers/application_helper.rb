# frozen_string_literal: true

module ApplicationHelper
  def printable_due_date(topic)
    if topic.active?
      if topic.due_date.present?
        if topic.days_remaining.negative?
          "#{pluralize(topic.days_remaining.abs, 'day')} overdue"
        else
          "#{pluralize(topic.days_remaining, 'day')} remaining"
        end
      else
        'No due date set'
      end
    else
      'Already resolved'
    end
  end
end
