# frozen_string_literal: true

module Teams
  class UsersController < ApplicationController
    def create
      @team = Team.find(params[:team_id])
      @team.users << User.find(params[:user_id])

      redirect_to edit_team_path(@team),
                  flash: { success: 'User was successfully added to the team.' }
    end

    def destroy
      @team = Team.find(params[:team_id])
      @user = User.find(params[:id])
      @team.users.delete(@user)

      redirect_to edit_team_path(@team),
                  flash: { success: 'User was successfully removed from the team.' }
    end
  end
end
