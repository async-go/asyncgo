# frozen_string_literal: true

module Teams
  module Topics
    class ApplicationController < ::Teams::ApplicationController
      protected

      def topic
        @topic ||= team.topics.find(params[:topic_id] || params[:id])
      end

      def parse_markdown(markdown)
        CommonMarker.render_html(markdown, :DEFAULT, %i[tasklist tagfilter autolink])
      end
    end
  end
end
