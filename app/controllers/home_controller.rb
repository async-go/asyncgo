# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if current_user
      redirect_to current_user_destination
    else
      render :index
    end
  end

  def current_user_destination
    if current_user.team
      if params[:do] == 'newTopic'
        new_team_topic_path(current_user.team, params: do_params)
      else
        team_topics_path(current_user.team)
      end
    else
      new_team_path
    end
  end

  def do_params
    params.permit(:selection, :context)
  end

end
