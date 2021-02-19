# frozen_string_literal: true

require './spec/support/sign_in_out_request_helpers'

RSpec.describe SessionsController, type: :request do
  include SignInOutRequestHelpers

  describe 'DELETE destroy' do
    subject(:delete_destroy) { delete '/sign_out' }

    let(:user) { FactoryBot.create(:user) }

    context 'when user is signed in' do
      before do
        sign_in(user)
      end

      it 'logs the user out' do
        expect { delete_destroy }.to change { controller.send(:current_user) }.from(user).to(nil)
      end

      it 'sets the flash' do
        delete_destroy

        expect(controller.flash[:success]).to eq('You have been signed out.')
      end

      it 'redirects to root path' do
        expect(delete_destroy).to redirect_to(root_path)
      end
    end

    context 'when the user is not signed in' do
      it 'sets the flash' do
        delete_destroy

        expect(controller.flash[:success]).to eq('You have been signed out.')
      end

      it 'redirects to root path' do
        expect(delete_destroy).to redirect_to(root_path)
      end
    end
  end
end
