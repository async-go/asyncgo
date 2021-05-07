# frozen_string_literal: true

class MarkdownParser < ApplicationService
  require 'redcarpet'
  require 'redcarpet/render_strip'

  MENTION_REGEX = /(?<=\s)@([\w.\-_]+)?\w+@[\w\-_]+(\.\w+)+\b/

  def initialize(user, text, notification_target)
    super()

    @user = user
    @text = text
    @notification_target = notification_target
  end

  def call
    result = process_mentions(@text)
    html_output = process_markdown(result)
    process_links(html_output)
  end

  private

  def process_mentions(markdown)
    redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    text = redcarpet.render(markdown)
    text.gsub(MENTION_REGEX) do |mention|
      email = mention.slice(1..-1)
      target_user = User.find_by(email: email)
      notify_user!(target_user)

      "[#{target_user.printable_name}](mailto:#{email})"
    end
    markdown
  end

  def process_markdown(markdown)
    CommonMarker.render_html(markdown, :DEFAULT, %i[table tasklist tagfilter autolink])
  end

  def process_links(html_output)
    Nokogiri::HTML.fragment(html_output).tap do |doc|
      doc.css('a').each do |link|
        link['target'] = '_blank'
        link['rel'] = 'noopener'
      end
    end.to_s
  end

  def notify_user!(target_user)
    return if target_user.id == @user.id

    @notification_target.notifications.build(actor: @user, user: target_user, action: :mentioned)
  end
end
