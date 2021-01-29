# frozen_string_literal: true

RSpec.describe ApplicationHelper, type: :helper do
  describe '#notifications' do
    subject(:notifications) { helper.notifications }

    let(:current_user) { FactoryBot.create(:user) }
    let(:user_notification) { FactoryBot.create(:notification, user: current_user) }

    before do
      without_partial_double_verification do
        allow(helper).to receive(:current_user).and_return(current_user)
      end

      FactoryBot.create(:notification)
    end

    it 'returns users notifications' do
      expect(notifications).to contain_exactly(user_notification)
    end
  end

  describe '#notification_text' do
    subject(:notification_text) { helper.notification_text(notification) }

    let(:notification) { FactoryBot.create(:notification) }

    context 'when target is topic' do
      before do
        notification.update!(target: FactoryBot.create(:topic))
      end

      it { is_expected.to eq("#{notification.actor.printable_name} updated the topic #{notification.target.title}") }
    end

    context 'when target is comment' do
      before do
        notification.update!(target: FactoryBot.create(:comment))
      end

      it do
        expect(notification_text).to eq(
          "#{notification.actor.printable_name} updated a comment in the topic #{notification.target.topic.title}"
        )
      end
    end
  end
end
