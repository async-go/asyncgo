# frozen_string_literal: true

class TeamsController < ApplicationController
  def edit
    @team = Team.find(params[:id])
  end
end
