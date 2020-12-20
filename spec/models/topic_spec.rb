# frozen_string_literal: true

RSpec.describe Topic, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:team) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end
end
