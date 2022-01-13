# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'Validations' do
    before do
      create(:user)
    end

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.not_to allow_value('thisisnotanemail', nil).for(:email) }
    it { is_expected.to allow_value('test@example.com').for(:email) }

    it { is_expected.not_to allow_value('', ' ').for(:name) }
    it { is_expected.to allow_value(nil).for(:name) }

    it { is_expected.to validate_presence_of(:preferences) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:team).optional }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:topics).dependent(:destroy) }
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
    it { is_expected.to have_many(:subscribed_topics) }
    it { is_expected.to have_many(:notifications).inverse_of(:user) }
    it { is_expected.to have_one(:preferences) }
  end

  describe '.from_omniauth' do
    subject(:from_omniauth) { described_class.from_omniauth(email, name) }

    let(:email) { 'john@example.com' }
    let(:name) { 'John Sample' }

    context 'when a user exists' do
      let!(:user) { create(:user, email: 'john@example.com') }

      it 'does not create user' do
        expect { from_omniauth }.not_to change(described_class, :count).from(1)
      end

      it 'does not create user preferences' do
        expect { from_omniauth }.not_to change(User::Preferences, :count).from(1)
      end

      it 'returns existing user' do
        expect(from_omniauth).to eq(user)
      end

      it 'updates user name' do
        expect { from_omniauth }.to change { user.reload.name }.from(nil).to('John Sample')
      end

      it 'sets the last login time' do
        expect(from_omniauth.last_login).not_to equal(nil)
      end
    end

    context 'when user does not exist' do
      it 'creates user' do
        expect { from_omniauth }.to change(described_class, :count).from(0).to(1)
      end

      it 'creates user preferences' do
        expect { from_omniauth }.to change(User::Preferences, :count).from(0).to(1)
      end

      it 'returns new user' do
        expect(from_omniauth).to have_attributes(email: 'john@example.com', name: 'John Sample')
      end

      it 'sets the last login time' do
        expect(from_omniauth.last_login).not_to equal(nil)
      end
    end
  end

  describe '#printable_name' do
    subject(:printable_name) { user.printable_name }

    let(:user) { build(:user) }

    context 'when user does not have name' do
      it { is_expected.to eq(user.email) }
    end

    context 'when user has name' do
      before do
        user.name = 'John Doe'
      end

      it { is_expected.to eq(user.name) }
    end
  end

  describe '#gravatar_url' do
    subject(:gravatar_url) { user.gravatar_url }

    let(:user) { build(:user, email: 'test@test.com') }

    it { is_expected.to eq('https://www.gravatar.com/avatar/b642b4217b34b1e8d3bd915fc65c4452') }
  end

  describe '#clear_topic_notifications' do
    subject(:clear_topic_notifications) { user.clear_topic_notifications(topic) }

    let(:user) { create(:user) }
    let(:topic) { create(:topic) }

    before do
      comment = create(:comment, topic:)
      create(:notification, target: comment, user:)
      create(:notification, target: topic, user:)
    end

    it 'clears topic and comment notifications' do
      expect { clear_topic_notifications }.to change { user.notifications.where(read_at: nil).count }.from(2).to(0)
    end
  end
end
