# frozen_string_literal: true

RSpec.describe Users::NotificationsHelper, type: :helper do
  describe '#notification_text' do
    subject(:notification_text) { helper.notification_text(notification) }

    let(:notification) { create(:notification) }

    context 'when target is topic' do
      before do
        notification.update!(target: create(:topic))
      end

      context 'when action is updated' do
        before do
          notification.update!(action: :updated)
        end

        it { is_expected.to eq("#{notification.actor.printable_name} updated the topic #{notification.target.title}") }
      end

      context 'when action is created' do
        before do
          notification.update!(action: :created)
        end

        it { is_expected.to eq("#{notification.actor.printable_name} created the topic #{notification.target.title}") }
      end

      context 'when action is expiring' do
        before do
          notification.update!(action: :expiring)
        end

        it { is_expected.to eq("The topic #{notification.target.title} is due in less than one day.") }
      end

      context 'when action is mentioned' do
        before do
          notification.update!(action: :mentioned)
        end

        it do
          expect(notification_text).to eq(
            "#{notification.actor.printable_name} mentioned you in the topic #{notification.target.title}"
          )
        end
      end
    end

    context 'when target is comment' do
      before do
        notification.update!(target: create(:comment))
      end

      context 'when action is created' do
        before do
          notification.update!(action: :created)
        end

        it do
          expect(notification_text).to eq(
            "#{notification.actor.printable_name} created a comment in the topic #{notification.target.topic.title}"
          )
        end
      end

      context 'when action is mentioned' do
        before do
          notification.update!(action: :mentioned)
        end

        it do
          expect(notification_text).to eq(
            <<-NOTIFICATION_TEXT.squish
          #{notification.actor.printable_name}
          mentioned you in a comment in the topic
          #{notification.target.topic.title}
          NOTIFICATION_TEXT
          )
        end
      end
    end
  end
end
