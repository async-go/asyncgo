# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::SubscriptionsController, type: :request do
  describe 'GET edit' do
    subject(:get_edit) { get "/teams/#{team.id}/subscription/edit" }

    let(:team) { FactoryBot.create(:team) }

    context 'when user is authorized' do
      let(:user) { FactoryBot.create(:user, team: team) }

      before do
        sign_in(user)
      end

      it 'redirects to FastSpring account management' do
        service_double = instance_double(FastSpringAccountLinker, call: 'https://example.org')
        allow(::FastSpringAccountLinker).to receive(:new).with(user.email).and_return(service_double)

        expect(get_edit).to redirect_to('https://example.org')
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'POST webhook' do
    subject(:post_webhook) do
      post "/teams/#{team.id}/subscription/webhook",
           params: payload, as: :json, headers: { 'X-FS-Signature' => payload_hash }
    end

    let(:team) { FactoryBot.create(:team) }
    let(:other_team) { FactoryBot.create(:team) }
    let(:crypto_key) { '1234' }

    let(:payload) do
      {
        events: [
          {
            'id' => '111',
            'type' => 'subscription.activated',
            'tags' => { 'teamId' => team.id }
          },
          {
            'id' => '222',
            'type' => 'subscription.deactivated',
            'tags' => { 'teamId' => other_team.id }
          },
          {
            'id' => '1234',
            'type' => 'invalid_type',
            'tags' => { 'teamId' => team.id }
          }
        ]
      }
    end

    before do
      other_team.create_team_subscription!(active: true)

      allow(ENV).to receive(:[])
      allow(ENV).to receive(:[]).with('FASTSPRING_CRYPTO_KEY').and_return(crypto_key)
    end

    context 'when payload is valid' do
      let(:payload_hash) do
        Base64.encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest.new('sha256'), crypto_key, payload.to_json
          )
        ).chomp
      end

      it 'returns accepted' do
        post_webhook

        expect(response).to have_http_status(:accepted)
      end

      it 'processed only valid event' do
        post_webhook

        expect(response.body).to eq('111\n222')
      end

      it 'activates team subscriptions' do
        expect { post_webhook }.to change { team.reload.team_subscription }
          .from(nil).to(having_attributes(active: true))
      end

      it 'deactivates team subscriptions' do
        expect { post_webhook }.to change { other_team.team_subscription.reload.active }.from(true).to(false)
      end
    end

    context 'when payload is invalid' do
      let(:payload_hash) { 'invalid-hash' }

      it 'returns unauthorized' do
        post_webhook

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when payload has wrong crypto key' do
      let(:payload_hash) do
        Base64.encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest.new('sha256'), 'invalid_key', payload.to_json
          )
        ).chomp
      end

      it 'returns unauthorized' do
        post_webhook

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
