# frozen_string_literal: true

class NewController < Teams::ApplicationController
  def topic
    if current_user&.team
      redirect_to new_team_topic_path(current_user.team.id, params: topic_params)
    else
      redirect_to root_path
    end
  end

  private

  def topic_params
    params.permit(:selection, :context)
  end
end
