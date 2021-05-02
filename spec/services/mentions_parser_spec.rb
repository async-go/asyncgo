# frozen_string_literal: true

RSpec.describe MentionsParser, type: :service do
  let(:user) { FactoryBot.create(:user, :team) }
  let(:target_user) { FactoryBot.create(:user, :name, team: user.team) }
  let(:text) { "This is a test for @#{target_user.email}" }
  let(:target) { FactoryBot.create(:topic, team: user.team) }

  describe '#call' do
    subject(:call) { described_class.new(user, text, target).call }

    it 'processes mentions' do
      expect(call).to include(
        "<a href=\"mailto:#{target_user.email}\" target=\"_blank\" rel=\"noopener\">#{target_user.name}</a>"
      )
    end
  end
end
