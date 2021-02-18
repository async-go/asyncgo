# frozen_string_literal: true

RSpec.describe Teams::TopicsHelper, type: :helper do
  include ActiveSupport::Testing::TimeHelpers

  describe '#user_subscribed?' do
    subject(:user_subscribed?) { helper.user_subscribed?(topic) }

    let(:topic) { FactoryBot.create(:topic) }
    let(:current_user) { FactoryBot.create(:user, team: topic.team) }

    before do
      without_partial_double_verification do
        allow(helper).to receive(:current_user).and_return(current_user)
      end
    end

    context 'when user is subscribed' do
      before do
        topic.subscribed_users << current_user
      end

      it { is_expected.to eq(true) }
    end

    context 'when user is not subscribed' do
      it { is_expected.to eq(false) }
    end
  end

  describe '#printable_due_date' do
    subject(:printable_due_date) { helper.printable_due_date(topic) }

    let(:topic) { FactoryBot.build(:topic) }

    context 'when topic does not have due date' do
      it { is_expected.to eq('No due date') }
    end

    context 'when topic has due date and is active' do
      before do
        topic.due_date = Time.utc(2020, 1, 1)
        topic.status = :active
      end

      context 'when topic is overdue' do
        before do
          travel_to(Time.utc(2020, 1, 2))
        end

        after do
          travel_back
        end

        it { is_expected.to eq('Due less than a minute ago') }
      end

      context 'when topic is not overdue' do
        before do
          travel_to(Time.utc(2019, 12, 30))
        end

        after do
          travel_back
        end

        it { is_expected.to eq('Due in 3 days') }
      end
    end

    context 'when topic has due date and is closed' do
      before do
        topic.due_date = Time.utc(2020, 1, 1)
        topic.status = :closed
      end

      it { is_expected.to eq('Due Jan 1') }
    end
  end

  describe 'topic_has_notification?' do
    subject(:topic_has_notification?) { helper.topic_has_notification?(notifications, target) }

    let(:user) { FactoryBot.create(:user, :team) }
    let(:unrelated_notification) { FactoryBot.create(:notification, user: user) }

    context 'when target is topic' do
      let(:target) { FactoryBot.create(:topic, user: user, team: user.team) }

      context 'when there are no notifications' do
        let(:notifications) { Notification.where(id: unrelated_notification.id) }

        it { is_expected.to eq(false) }
      end

      context 'when there are notifications' do
        let(:notifications) do
          Notification.where(
            id: [unrelated_notification.id, FactoryBot.create(:notification, user: user, target: target).id]
          )
        end

        it { is_expected.to eq(true) }
      end
    end

    context 'when target is comment' do
      let(:target) { FactoryBot.create(:comment, user: user) }

      context 'when there are no notifications' do
        let(:notifications) { Notification.where(id: unrelated_notification.id) }

        it { is_expected.to eq(false) }
      end

      context 'when there are notifications' do
        let(:notifications) do
          Notification.where(
            id: [unrelated_notification.id, FactoryBot.create(:notification, user: user, target: target).id]
          )
        end

        it { is_expected.to eq(true) }
      end
    end
  end

  describe '#emoji_group_text' do
    subject(:emoji_group_text) { helper.emoji_group_text('cat', 2) }

    it { is_expected.to eq("#{Emoji.find_by_alias('cat').raw} 2") } # rubocop:disable Rails/DynamicFindBy
  end
end
