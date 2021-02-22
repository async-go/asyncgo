# frozen_string_literal: true

RSpec.describe MarkdownParser, type: :service do
  let(:user) { FactoryBot.create(:user, :team) }
  let(:target_user) { FactoryBot.create(:user, :name, team: user.team) }
  let(:target) { FactoryBot.create(:topic, team: user.team) }
  let(:text) { "This is a __bold__ test for @#{target_user.email}" }

  describe '#call' do
    subject(:call) { described_class.new(user, text, target).call }

    it 'processes mentions' do
      expect(call).to include("<a href=\"mailto:#{target_user.email}\">#{target_user.name}</a>")
    end

    it 'processes markdowns' do
      expect(call).to include('<strong>bold</strong>')
    end

    it 'creates a notification for the mentioned user' do
      expect { call }.to change { target_user.reload.notifications.count }.from(0).to(1)
    end

    context 'when target user is self' do
      let(:target_user) { user }

      it 'does not create a notification for user' do
        expect { call }.not_to change { target_user.reload.notifications.count }.from(0)
      end
    end
  end
end
