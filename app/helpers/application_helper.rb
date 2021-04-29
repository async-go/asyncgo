# frozen_string_literal: true

module ApplicationHelper
  def active_link_to(text, path, class_names)
    link_to text, path, class: class_names(class_names, active: current_page?(path))
  end

  def assistive_icon(source, icon, title, classname: nil)
    icon(source, icon, class: classname, title: title) + tag.span(title, class: 'visually-hidden')
  end

  def new_updates_button(link, date)
    color = Time.zone.today - date < 7 ? 'success' : 'secondary'
    link_to link, class: "button btn btn-sm btn-outline-#{color} mx-3 d-none d-lg-inline-block",
                  target: '_blank', rel: 'noopener' do
      assistive_icon('fas', 'seedling', "What's New")
    end
  end

  def emoji_group_text(emoji_name, count)
    "#{Emoji.find_by_alias(emoji_name).raw} #{count}" # rubocop:disable Rails/DynamicFindBy
  end

  def fastspring_store_url
    ENV['FASTSPRING_STORE_URL']
  end
end
