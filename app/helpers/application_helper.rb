# frozen_string_literal: true

module ApplicationHelper
  def assistive_icon(source, icon, title, classname: nil)
    icon(source, icon, class: classname, title: title) + tag.span(title, class: 'visually-hidden')
  end

  def emoji_group_text(emoji_name, count)
    "#{Emoji.find_by_alias(emoji_name).raw} #{count}" # rubocop:disable Rails/DynamicFindBy
  end

  def fastspring_store_url
    Rails.application.config.x.fastspring.store_url
  end
end
