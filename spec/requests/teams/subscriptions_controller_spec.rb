# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::SubscriptionsController, type: :request do
  describe 'GET edit' do
    subject(:get_edit) { get "/teams/#{team.id}/subscription/edit" }

    let(:team) { create(:team) }

    context 'when user is authorized' do
      let(:user) { create(:user, team:) }

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
end
