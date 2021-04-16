# frozen_string_literal: true

module ApplicationHelper
  def active_link_to(text, path, class_names)
    link_to text, path, class: class_names(class_names, active: current_page?(path))
  end

  def assistive_icon(source, icon, title, classname: nil)
    icon(source, icon, class: classname, title: title) + tag.span(title, class: 'visually-hidden')
  end

  def emoji_group_text(emoji_name, count)
    "#{Emoji.find_by_alias(emoji_name).raw} #{count}" # rubocop:disable Rails/DynamicFindBy
  end
end
