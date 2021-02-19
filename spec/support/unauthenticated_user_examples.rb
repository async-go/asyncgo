# frozen_string_literal: true

require './spec/support/sign_in_out_request_helpers'

RSpec.shared_examples 'unauthenticated user examples' do
  include SignInOutRequestHelpers

  context 'when user is not authenticated' do
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
