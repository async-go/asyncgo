# frozen_string_literal: true

module Teams
  module Topics
    module Comments
      class ApplicationController < ::Teams::Topics::ApplicationController
        protected

        def comment
          @comment ||= topic.comments.find(params[:comment_id] || params[:id])
        end
      end
    end
  end
end
