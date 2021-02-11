# frozen_string_literal: true

module ApplicationHelper
  def notification_text(notification)
    case notification.target
    when Comment
      comment_notification_text(notification)
    when Topic
      topic_notification_text(notification)
    end
  end

  def active_link_to(text, path, class_names)
    link_to text, path, class: class_names(class_names, active: current_page?(path))
  end

  def assistive_icon(source, icon, title, classname: nil)
    icon(source, icon, class: classname) + tag.span(title, class: 'visually-hidden')
  end

  private

  def topic_notification_text(notification)
    case notification.action
    when 'expiring'
      "The topic #{notification.target.title} is due in less than one day."
    when 'created', 'updated'
      "#{notification.actor.printable_name} #{notification.action} the topic #{notification.target.title}"
    end
  end

  def comment_notification_text(notification)
    <<-NOTIFICATION_TEXT.squish
      #{notification.actor.printable_name}
      #{notification.action}
      a comment in the topic
      #{notification.target.topic.title}
    NOTIFICATION_TEXT
  end
end
