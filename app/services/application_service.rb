# frozen_string_literal: true

class ApplicationService
  def call
    raise NotImplementedError
  end

  private

  def parse_markdown(markdown)
    CommonMarker.render_html(markdown, :DEFAULT, %i[tasklist tagfilter autolink])
  end
end
