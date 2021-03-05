# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe Users::PreferencesController, type: :request do
  describe 'PATCH update' do
    subject(:patch_update) do
      patch "/users/#{user.id}/preference",
            params: { user_preference: { digest_enabled: 'false', widescreen_enabled: 'false' } }
    end

    let(:user) { FactoryBot.create(:user) }

    context 'when user is authorized' do
      before do
        sign_in(user)
      end

      it 'updates the digest preferences' do
        expect { patch_update }.to change { user.preference.reload.digest_enabled }.from(true).to(false)
      end

      it 'updates the widescreen preferences' do
        expect { patch_update }.to change { user.preference.reload.widescreen_enabled }.from(true).to(false)
      end

      it 'redirects to edit user' do
        patch_update

        expect(response).to redirect_to(edit_user_path(user))
      end
    end

    include_examples 'unauthorized user examples'
  end
end
