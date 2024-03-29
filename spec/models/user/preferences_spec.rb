# frozen_string_literal: true

RSpec.describe User::Preferences, type: :model do
  describe 'Validations' do
    before do
      create(:user)
    end

    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_uniqueness_of(:user_id) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:user) }
  end
end
