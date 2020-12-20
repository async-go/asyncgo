# frozen_string_literal: true

module Teams
  module Topics
    class ApplicationController < ::Teams::ApplicationController
      protected

      def topic
        @topic ||= team.topics.find(params[:topic_id] || params[:id])
      end
    end
  end
end
