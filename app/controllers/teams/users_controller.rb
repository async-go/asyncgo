# frozen_string_literal: true

module Teams
  class UsersController < Teams::ApplicationController
    include Pundit

    def create
      @team = team
      authorize(@team, policy_class: Teams::UserPolicy)

      user = User.find_or_create_by(user_params)
      @team.users << user

      if user.persisted?
        user_flash = { success: 'User was successfully added to the team.' }
        UserMailer.with(user: user).welcome_email.deliver_later
      else
        user_flash = { danger: user.errors.full_messages.join(', ') }
      end

      redirect_to edit_team_path(@team), flash: user_flash
    end

    def destroy
      @team = team
      user = @team.users.find_by(user_params)
      authorize([:teams, user])

      @team.users.delete(user)
      redirect_to edit_team_path(@team),
                  flash: { success: 'User was successfully removed from the team.' }
    end

    private

    def user_params
      params.require(:user).permit(:id, :email)
    end
  end
end
