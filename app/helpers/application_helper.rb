# frozen_string_literal: true

module ApplicationHelper
  require 'digest'

  def active_link_to(text, path, class_names)
    link_to text, path, class: class_names(class_names, active: current_page?(path))
  end

  def assistive_icon(source, icon, title, classname: nil)
    icon(source, icon, class: classname) + tag.span(title, class: 'visually-hidden')
  end

  def checksum(object)
    Digest::MD5.hexdigest object
  end
end
