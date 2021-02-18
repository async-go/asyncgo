# frozen_string_literal: true

require './spec/support/sign_in_out_request_helpers'
require './spec/support/unauthorized_user_examples'

RSpec.describe Users::PreferencesController, type: :request do
  include SignInOutRequestHelpers

  describe 'PATCH update' do
    subject(:patch_update) do
      patch "/users/#{user.id}/preference", params: { user_preference: { digest_enabled: 'true' } }
    end

    let(:user) { FactoryBot.create(:user) }

    context 'when user is authenticated' do
      let(:browsing_user) { FactoryBot.create(:user) }

      before do
        sign_in(browsing_user)
      end

      context 'when user is authorized' do
        let(:browsing_user) { user }

        it 'updates the user preferences' do
          expect { patch_update }.to change { user.preference.reload.digest_enabled }.from(false).to(true)
        end

        it 'redirects to edit user' do
          patch_update

          expect(response).to redirect_to(edit_user_path(user))
        end
      end

      context 'when user is not authorized' do
        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end
end
