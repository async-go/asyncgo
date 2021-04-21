# frozen_string_literal: true

module Teams
  class SubscriptionsController < Teams::ApplicationController
    def edit
      authorize(team)

      redirect_to ::FastSpringAccountLinker.new(current_user.email).call
    end
  end
end
