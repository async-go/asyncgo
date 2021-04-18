# frozen_string_literal: true

require './lib/fast_spring'

module Teams
  class BillingsController < Teams::ApplicationController
    def edit
      redirect_to ::FastSpring.generate_account_management_link(current_user.email)
    end
  end
end
