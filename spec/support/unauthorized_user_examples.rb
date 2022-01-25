# frozen_string_literal: true

require './spec/support/unauthenticated_user_examples'
require './spec/support/sign_in_out_request_helpers'

RSpec.shared_examples 'unauthorized user examples' do
  include SignInOutRequestHelpers

  include_examples 'unauthenticated user examples'

  context 'when user is authenticated but not authorized' do
    before do
      sign_in(create(:user))
    end

    it 'sets the alert flash' do
      subject
      follow_redirect!

      expect(controller.flash[:warning]).to eq('You are not authorized.')
    end

    it 'redirects the user back (to root)' do
      expect(subject).to redirect_to(root_path)
    end
  end
end
