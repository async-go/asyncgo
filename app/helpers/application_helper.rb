# frozen_string_literal: true

module ApplicationHelper
  def active_link_to(text, path, class_names)
    link_to text, path, class: class_names(class_names, active: current_page?(path))
  end

  def assistive_icon(source, icon, title, classname: nil)
    icon(source, icon, class: classname, title: title) + tag.span(title, class: 'visually-hidden')
  end

  def whatsnew_button(link, date)
    color = Time.zone.today - date < 7 ? 'success' : 'secondary'
    link_to link, target: '_blank', rel: 'noopener',
                  class: "button ms-3 btn btn-sm btn-outline-#{color} me-3 d-none d-lg-block" do
      assistive_icon('fas', 'seedling', "What's New", classname: 'me-1') + tag.span("What's New")
    end
  end

  def emoji_group_text(emoji_name, count)
    "#{Emoji.find_by_alias(emoji_name).raw} #{count}" # rubocop:disable Rails/DynamicFindBy
  end
end
