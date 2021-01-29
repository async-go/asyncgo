# frozen_string_literal: true

module ApplicationHelper
  def notifications
    Notification.where(user: current_user, read_at: nil)
  end

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
end
