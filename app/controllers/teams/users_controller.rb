# frozen_string_literal: true

module Teams
  class UsersController < Teams::ApplicationController
    def create
      @team = team
      Pundit.authorize(current_user, @team, :create?, policy_class: Teams::UserPolicy)

      @team.users << User.find(params[:user_id])

      redirect_to edit_team_path(@team),
                  flash: { success: 'User was successfully added to the team.' }
    end

    def destroy
      @team = team
      @user = User.find(params[:id])
      Pundit.authorize(current_user, @team, :destroy?, policy_class: Teams::UserPolicy)

      @team.users.delete(@user)

      redirect_to edit_team_path(@team),
                  flash: { success: 'User was successfully removed from the team.' }
    end
  end
end
