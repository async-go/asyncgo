# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:username) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:team).optional }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end
end
