# frozen_string_literal: true

module Teams
  class ApplicationController < ::ApplicationController
    protected

    def team
      @team ||= current_user.team
    end
  end
end
