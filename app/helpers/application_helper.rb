# frozen_string_literal: true

module ApplicationHelper
  def notifications
    Notification.where(user: current_user, read_at: nil)
  end

  def notification_text(notification)
    "#{notification.actor.printable_name} #{notification.action} an #{notification.target.class.to_s.downcase}"
  end

  def active_link_to(text, path, class_names)
    link_to text, path, class: class_names(class_names, active: current_page?(path))
  end
end
