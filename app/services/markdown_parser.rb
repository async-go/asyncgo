# frozen_string_literal: true

class MarkdownParser < ApplicationService
  MENTION_REGEX = /(?<=\s)@([\w.\-_]+)?\w+@[\w\-_]+(\.\w+)+\b/

  def initialize(user, text)
    super()

    @user = user
    @text = text
  end

  def call
    result = process_mentions(@text)
    process_markdown(result)
  end

  private

  def process_mentions(text)
    text.gsub(MENTION_REGEX) do |mention|
      email = mention.slice(1..-1)
      target_user = User.find_by(email: email)

      "[#{target_user.printable_name}](mailto:#{email})"
    end
  end

  def process_markdown(markdown)
    CommonMarker.render_html(markdown, :DEFAULT, %i[tasklist tagfilter autolink])
  end
end
