# frozen_string_literal: true

module Teams
  class UsersController < Teams::ApplicationController
    include Pundit

    def create
      @team = team
      authorize(@team, policy_class: Teams::UserPolicy)

      user = User.find_or_create_by(email: params[:user_email])
      @team.users << user

      redirect_to edit_team_path(@team),
                  flash: { success: 'User was successfully added to the team.' }
    end

    def destroy
      user = User.find(params[:id])
      authorize([:teams, user])

      @team = team
      @team.users.delete(user)

      redirect_to edit_team_path(@team),
                  flash: { success: 'User was successfully removed from the team.' }
    end
  end
end
