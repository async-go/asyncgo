# frozen_string_literal: true

class ExtensionController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new_topic
    authorize(current_user, policy_class: ExtensionPolicy)

    redirect_to new_team_topic_path(current_user.team, params: new_topic_params)
  end

  private

  def new_topic_params
    params.permit(:selection, :context)
  end
end
