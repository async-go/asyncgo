# frozen_string_literal: true

module ApplicationHelper
  def notification_text(notification)
    case notification.target
    when Comment
      # rubocop:disable Layout/LineLength
      "#{notification.actor.printable_name} #{notification.action} a comment in the topic #{notification.target.topic.title}"
      # rubocop:enable Layout/LineLength
    when Topic
      if notification.expiring?
        "The topic #{notification.target.title} is due in less than one day."
      else
        "#{notification.actor.printable_name} #{notification.action} the topic #{notification.target.title}"
      end
    end
  end

  def active_link_to(text, path, class_names)
    link_to text, path, class: class_names(class_names, active: current_page?(path))
  end

  def assistive_icon(source, icon, title, classname: nil)
    icon(source, icon, class: classname) + tag.span(title, class: 'visually-hidden')
  end
end
