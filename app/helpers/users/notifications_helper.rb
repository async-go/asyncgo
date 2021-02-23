# frozen_string_literal: true

module Users
  module NotificationsHelper
    include ::Pagy::Frontend

    def notification_text(notification)
      case notification.target
      when Comment
        comment_notification_text(notification)
      when Topic
        topic_notification_text(notification)
      end
    end

    private

    def topic_notification_text(notification)
      case notification.action
      when 'expiring'
        "The topic #{notification.target.title} is due in less than one day."
      when 'created', 'updated'
        "#{notification.actor.printable_name} #{notification.action} the topic #{notification.target.title}"
      when 'mentioned'
        "#{notification.actor.printable_name} mentioned you in the topic #{notification.target.title}"
      end
    end

    def comment_notification_text(notification)
      case notification.action
      when 'created', 'updated'
        <<-NOTIFICATION_TEXT.squish
        #{notification.actor.printable_name}
        #{notification.action}
        a comment in the topic
        #{notification.target.topic.title}
        NOTIFICATION_TEXT
      when 'mentioned'
        <<-NOTIFICATION_TEXT.squish
        #{notification.actor.printable_name}
        mentioned you in a comment in the topic
        #{notification.target.topic.title}
        NOTIFICATION_TEXT
      end
    end
  end
end
