# frozen_string_literal: true

module Teams
  class UsersController < Teams::ApplicationController
    def index
      authorize(team, policy_class: Teams::UserPolicy)

      respond_to do |format|
        format.json do
          users = team.users.map { |user| { key: user.printable_name, value: user.email } }
          render json: users
        end
      end
    end

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
      { email: params[:user][:email].downcase.strip }
    end

    def send_welcome_email(user)
      UserMailer.with(user: user).welcome_email.deliver_later
    end

    # rubocop:disable Metrics/MethodLength
    def add_user_to_team(team, user)
      if team.users.count > 5
        { danger: 'You have reached the maximum 5 users on the free plan.' }
      elsif !user.valid?
        { danger: "There was a problem adding the user to the team. #{user.errors.full_messages.join(', ')}." }
      elsif user.team
        { danger: 'User already belongs to a team.' }
      else
        team.users << user
        send_welcome_email(user)
        { success: 'User was successfully added to the team.' }
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
