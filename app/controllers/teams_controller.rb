# frozen_string_literal: true

class TeamsController < Teams::ApplicationController
  include Pundit

  def edit
    @team = team
    authorize(@team)
  end

  def new
    @team = Team.new
    authorize(@team)
  end

  def create
    @team = Team.new(team_params)
    authorize(@team)

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
