# frozen_string_literal: true

module Teams
  class UsersController < Teams::ApplicationController
    include Pundit

    def create
      authorize(team, policy_class: Teams::UserPolicy)

      user = User.find_or_initialize_by(create_params)
      team.users << user

      if user.persisted?
        user_flash = { success: 'User was successfully added to the team.' }
        send_welcome_email(user)
      else
        user_flash = { danger: user.errors.full_messages.join(', ') }
      end

      redirect_to edit_team_path(team), flash: user_flash
    end

    def destroy
      user = team.users.find(params[:id])
      authorize([:teams, user])

      team.users.delete(user)
      redirect_to edit_team_path(team),
                  flash: { success: 'User was successfully removed from the team.' }
    end

    private

    def create_params
      params.require(:user).permit(:email, :name)
    end

    def send_welcome_email(user)
      UserMailer.with(user: user).welcome_email.deliver_later
    end
  end
end
