# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if current_user
      redirect_to team_topics_path(current_user)
    end
  end
end
