# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to new_team_path if current_user.present? && current_user.team_id.blank?
  end
end
