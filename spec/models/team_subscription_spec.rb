# frozen_string_literal: true

RSpec.describe TeamSubscription, type: :model do
  describe 'Validations' do
    before do
      team = FactoryBot.create(:team)
      described_class.create!(team: team)
    end

    it { is_expected.to validate_presence_of(:team_id) }
    it { is_expected.to validate_uniqueness_of(:team_id) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:team) }
  end
end
