# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'Validations' do
    before do
      FactoryBot.create(:user)
    end

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.not_to allow_value("", " ").for(:name) }
    it { is_expected.to allow_value(nil).for(:name) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:team).optional }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:topics).dependent(:destroy) }
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
    it { is_expected.to have_many(:subscribed_topics) }
  end

  describe '.from_omniauth' do
    subject(:from_omniauth) { described_class.from_omniauth(::Hashie::Mash.new(auth_hash)) }

    let(:auth_hash) do
      {
        provider: 'google_oauth2',
        info: {
          email: 'john@example.com',
          name: 'John Sample'
        }
      }
    end

    context 'when a user exists' do
      let!(:user) { FactoryBot.create(:user, email: 'john@example.com') }

      it 'does not create user' do
        expect { from_omniauth }.not_to change(described_class, :count).from(1)
      end

      it 'returns existing user' do
        expect(from_omniauth).to eq(user)
      end
    end

    context 'when user does not exist' do
      it 'creates user' do
        expect { from_omniauth }.to change(described_class, :count).from(0).to(1)
      end

      it 'returns new user' do
        expect(from_omniauth).to have_attributes(email: 'john@example.com')
      end
    end
  end
end
