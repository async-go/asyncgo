# frozen_string_literal: true

RSpec.describe FastSpringAccountLinker, type: :service do
  describe '#call' do
    subject(:call) { service.call }

    let(:email) { 'test@example.com' }
    let(:service) { described_class.new(email) }

    before do
      accounts_response = OpenStruct.new(body: { accounts: [{ id: '123' }] }.to_json)
      allow(service).to receive(:send_request).with(
        '/accounts', hash_including(email: email)
      ).and_return(accounts_response)

      authenticate_response = OpenStruct.new(body: { accounts: [{ url: 'helloworld' }] }.to_json)
      allow(service).to receive(:send_request).with('/accounts/123/authenticate').and_return(authenticate_response)
    end

    it { is_expected.to eq('helloworld#/subscriptions') }
  end
end