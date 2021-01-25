# frozen_string_literal: true

RSpec.describe Topic, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:team) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
    it { is_expected.to have_many(:subscribed_users) }
    it { is_expected.to have_many(:notifications) }
  end

  it { is_expected.to define_enum_for(:status).with_values(%i[active closed]) }
end
