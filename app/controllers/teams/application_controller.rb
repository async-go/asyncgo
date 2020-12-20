# frozen_string_literal: true

module Teams
  class ApplicationController < ::ApplicationController
    protected

    def team
      @team ||= Team.find(params[:team_id] || params[:id])
    end
  end
end
