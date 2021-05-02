# frozen_string_literal: true

RSpec.describe Vote, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:emoji) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:votable) }
  end
end
