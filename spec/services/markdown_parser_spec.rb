# frozen_string_literal: true

RSpec.describe MarkdownParser, type: :service do
  let(:user) { FactoryBot.create(:user, :team) }
  let(:topic) { FactoryBot.create(:topic, team: user.team) }
  let(:target) { FactoryBot.create(:user, team: user.team) }
  let(:non_target) { FactoryBot.create(:user, team: user.team) }
  let(:text) { "This is a __bold__ test for @#{target.email}, but not #{non_target.email}" }

  describe '#call' do
    subject(:call) { described_class.new(user, text, target).call }

    it 'creates links for mentions' do
      expect(call).to include(
        "<a href=\"mailto:#{target.email}\" target=\"_blank\" rel=\"noopener\">#{target.printable_name}</a>"
      )
    end

    it 'does not create links for mentions without a leading @' do
      expect(call).not_to include(
        "<a href=\"mailto:#{non_target.email}\" target=\"_blank\" rel=\"noopener\">#{non_target.name}</a>"
      )
    end

    it 'processes markdown' do
      expect(call).to include('<strong>bold</strong>')
    end

    it 'builds a notification for the @ mentioned user' do
      expect { call }.to(change { target.notifications.length }.from(0).to(1))
    end

    it 'does not build a notification for the listed (but not @ mentioned) user' do
      expect { call }.not_to(change { non_target.notifications.length })
    end

    context 'when target user is self' do
      let(:target) { user }

      it 'does not create a notification for user' do
        expect { call }.not_to(change { target.notifications.length })
      end
    end

    context 'when mention is autolinked' do
      let(:text) do
        <<~MESSAGE
          This is a __bold__ test for @[#{target.printable_name}](#{target.email}),
          but not [#{non_target.printable_name}](#{non_target.email}).
        MESSAGE
      end

      it 'processes markdown' do
        expect(call).to include('<strong>bold</strong>')
      end

      it 'builds a notification for the @ mentioned user' do
        expect { call }.to change { target.notifications.length }.from(0).to(1)
      end

      it 'does not build a notification for the listed (but not @ mentioned) user' do
        expect { call }.not_to(change { non_target.notifications.length })
      end

      context 'when target user is self' do
        let(:target) { user }

        it 'does not create a notification for user' do
          expect { call }.not_to change { target.notifications.length }.from(0)
        end
      end
    end
  end
end
