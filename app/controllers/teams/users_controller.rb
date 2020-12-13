# frozen_string_literal: true

module Teams
  class UsersController < ApplicationController
    def create
      @team = Team.find(params[:team_id])
      @team.users << User.find(params[:user_id])

      redirect_to edit_team_path(@team)
    end

    def destroy
      @team = Team.find(params[:team_id])
      @team.users.delete(User.find(params[:id]))

      redirect_to edit_team_path(@team)
    end
  end
end
