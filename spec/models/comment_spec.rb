# frozen_string_literal: true

RSpec.describe Comment, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:topic) }
  end
end
