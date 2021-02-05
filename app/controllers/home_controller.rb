# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to team_topics_path(current_user) if current_user&.team
  end
end
