# frozen_string_literal: true

module Teams
  class ApplicationController < ::ApplicationController
    protected

    def team
      params[:team_id] = current_user.team.id if params[:team_id] == '-'
      @team ||= Team.find(params[:team_id] || params[:id])
    end
  end
end
