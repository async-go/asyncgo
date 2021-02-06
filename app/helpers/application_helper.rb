# frozen_string_literal: true

module ApplicationHelper
  def notification_text(notification)
    case notification.target
    when Comment
      <<-NOTIFICATION_TEXT.squish
        #{notification.actor.printable_name}
        #{notification.action}
        a comment in the topic
        #{notification.target.topic.title}
      NOTIFICATION_TEXT
    when Topic
      "#{notification.actor.printable_name} #{notification.action} the topic #{notification.target.title}"
    end
  end

  def active_link_to(text, path, class_names)
    link_to text, path, class: class_names(class_names, active: current_page?(path))
  end

  def assistive_icon(source, icon, title, class: nil)
    icon = icon(source, icon, class: binding.local_variable_get(:class))
    span = tag.span(title, class: 'sr-only')
    icon + span
  end
end
