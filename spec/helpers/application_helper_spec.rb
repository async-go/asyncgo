# frozen_string_literal: true

RSpec.describe ApplicationHelper, type: :helper do
  describe '#notification_text' do
    subject(:notification_text) { helper.notification_text(notification) }

    let(:notification) { FactoryBot.create(:notification) }

    it { is_expected.to eq("#{notification.actor.printable_name} updated the topic \"#{notification.target.title}\"") }
  end
end
