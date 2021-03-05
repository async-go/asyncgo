# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe Users::PreferencesController, type: :request do
  describe 'PATCH update' do
    subject(:patch_update) do
      patch "/users/#{user.id}/preference", params: { user_preference: preference_params }
    end

    let(:user) { FactoryBot.create(:user) }

    context 'when user is authorized' do
      before do
        sign_in(user)
      end

      context 'when updating digest preference' do
        let(:preference_params) { { digest_enabled: 'false' } }

        it 'updates the digest preference' do
          expect { patch_update }.to change { user.preference.reload.digest_enabled }.from(true).to(false)
        end

        it 'redirects to edit user' do
          patch_update

          expect(response).to redirect_to(edit_user_path(user))
        end
      end

      context 'when updating layout preference' do
        let(:preference_params) { { fluid_layout: 'true' } }

        it 'updates the layout preference' do
          expect { patch_update }.to change { user.preference.reload.fluid_layout }.from(false).to(true)
        end

        it 'redirects to edit user' do
          patch_update

          expect(response).to redirect_to(edit_user_path(user))
        end
      end
    end

    include_examples 'unauthorized user examples' do
      let(:preference_params) { { digest_enabled: 'false' } }
    end
  end
end
