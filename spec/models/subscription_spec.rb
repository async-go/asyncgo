# frozen_string_literal: true

RSpec.describe Subscription, type: :model do
  describe 'Validations' do
    before do
      user = create(:user, :team)
      topic = create(:topic, team: user.team)
      described_class.create!(user:, topic:)
    end

    it { is_expected.to validate_uniqueness_of(:topic_id).scoped_to(:user_id) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:topic) }
  end
end
