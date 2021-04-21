# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe Users::PreferencesController, type: :request do
  describe 'PATCH update' do
    subject(:patch_update) do
      patch "/users/#{user.id}/preferences", params: { user_preferences: preferences_params }
    end

    let(:user) { FactoryBot.create(:user) }

    context 'when user is authorized' do
      before do
        sign_in(user)
      end

      context 'when updating digest preferences' do
        let(:preferences_params) { { digest_enabled: 'false' } }

        it 'updates the digest preferences' do
          expect { patch_update }.to change { user.preferences.reload.digest_enabled }.from(true).to(false)
        end

        it 'redirects to edit user' do
          patch_update

          expect(response).to redirect_to(edit_user_path(user))
        end
      end

      context 'when updating layout preferences' do
        let(:preferences_params) { { fluid_layout: 'true' } }

        it 'updates the layout preferences' do
          expect { patch_update }.to change { user.preferences.reload.fluid_layout }.from(false).to(true)
        end

        it 'redirects to edit user' do
          patch_update

          expect(response).to redirect_to(edit_user_path(user))
        end
      end
    end

    include_examples 'unauthorized user examples' do
      let(:preferences_params) { { digest_enabled: 'false' } }
    end
  end
end
