# frozen_string_literal: true

class NewController < Teams::ApplicationController
  def topic
    redirect_to new_team_topic_path(current_user.team.id), params: topic_params
  end

  private

  def topic_params
    params.permit(:selection, :context)
  end

end
