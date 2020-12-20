# frozen_string_literal: true

RSpec.describe Team, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'Relations' do
    it { is_expected.to have_many(:users).dependent(:nullify) }
    it { is_expected.to have_many(:topics).dependent(:destroy) }
  end
end
