# frozen_string_literal: true

RSpec.describe Team, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.not_to allow_value('Team name :').for(:name) }
    it { is_expected.not_to allow_value('Team name /').for(:name) }
    it { is_expected.not_to allow_value('Team name \\').for(:name) }
  end

  describe 'Relations' do
    it { is_expected.to have_many(:users).dependent(:nullify) }
    it { is_expected.to have_many(:topics).dependent(:destroy) }
  end
end
