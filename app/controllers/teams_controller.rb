# frozen_string_literal: true

class TeamsController < ApplicationController
  def edit
    @team = Team.find(params[:id])
    Pundit.authorize(current_user, @team, :edit?)
  end

  def new
    @team = Team.new
    Pundit.authorize(current_user, @team, :new?)
  end

  def create
    @team = Team.new(team_params)
    Pundit.authorize(current_user, @team, :create?)

    if @team.save
      @team.users << current_user
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
