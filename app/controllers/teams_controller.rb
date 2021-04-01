# frozen_string_literal: true

class TeamsController < Teams::ApplicationController
  include Pagy::Backend

  def edit
    @team = team
    authorize(@team)

    @pagy_members, @team_members = pagy(
      team.users.where.not(email: current_user.email).order(:created_at)
    )

    @pagy_owners, @team_owners = pagy(
      team.owners.order(:created_at) || nil
    )
  end

  def new
    @team = Team.new
    authorize(@team)
  end

  def create
    @team = Team.new(team_params)
    authorize(@team)

    if @team.save
      @team.owners << current_user
      @team.users << current_user
      redirect_to edit_team_path(@team),
                  flash: { success: 'Team was successfully created.' }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def support
    authorize(team)

    support_flash = if SupportMailer.with(user: current_user, body: params[:body]).support_email.deliver_later
                      { success: 'Support request was successfully sent.' }
                    else
                      { danger: 'Support request was not sent.' }
                    end

    redirect_to edit_team_path(team), flash: support_flash
  end

  def update
    authorize(team)

    if team.update(team_params)
      redirect_to edit_team_path(team),
                  flash: { success: 'Team was successfully updated.' }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :message)
  end
end
