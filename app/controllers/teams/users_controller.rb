# frozen_string_literal: true

module Teams
  class UsersController < Teams::ApplicationController
    include Pundit

    def create
      authorize(team, policy_class: Teams::UserPolicy)

      user = User.find_or_initialize_by(create_params).tap do |target_user|
        target_user.preference ||= target_user.build_preference
      end

      user_flash = add_user_to_team(team, user)
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
      params.require(:user).permit(:email)
    end

    def send_welcome_email(user)
      UserMailer.with(user: user).welcome_email.deliver_later
    end

    def add_user_to_team(team, user)
      if user.team
        { danger: 'User already belongs to a team.' }
      else
        team.users << user
        send_welcome_email(user)
        { success: 'User was successfully added to the team.' }
      end
    end
  end
end
