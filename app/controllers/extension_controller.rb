# frozen_string_literal: true

class ExtensionController < ApplicationController
  def new_topic
    authorize(current_user, policy_class: ExtensionPolicy)

    redirect_to new_team_topic_path(current_user.team, params: create_params)
  end

  private

  def create_params
    params.permit(:selection, :context)
  end
end
