# frozen_string_literal: true

class MentionsParser < ApplicationService
  MENTION_REGEX = /@([\w.\-_]+)?\w+@[\w\-_]+(\.\w+)+\b/

  def initialize(user, text, notification_target)
    super()

    @user = user
    @text = text
    @notification_target = notification_target
  end

  def call
    @text.gsub(MENTION_REGEX) do |mention|
      email = mention.slice(1..-1)
      target_user = User.find_by(email: email)
      notify_user!(target_user)

      "<a href=\"mailto:#{email}\" target=\"_blank\" rel=\"noopener\">#{target_user.printable_name}</a>"
    end
  end

  private

  def notify_user!(target_user)
    return if target_user.id == @user.id

    @notification_target.notifications.build(actor: @user, user: target_user, action: :mentioned)
  end
end
