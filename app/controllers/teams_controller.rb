# frozen_string_literal: true

class TeamsController < ApplicationController
  def edit
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    @team = current_user.build_team(team_params)

    if @team.save
      current_user.save
      redirect_to edit_team_path(@team),
                  flash: { success: 'Team was successfully created.' }
    else
      render :new
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
