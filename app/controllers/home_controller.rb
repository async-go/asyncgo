# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if current_user&.team
      redirect_to team_topics_path(current_user.team)
    elsif current_user
      redirect_to new_team_path
    else
      render :index
    end
  end
end
