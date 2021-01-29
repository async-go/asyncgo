# frozen_string_literal: true

module TeamsHelper
  def users_in_team(team)
    team.users.where.not(email: current_user.email)
  end
end
