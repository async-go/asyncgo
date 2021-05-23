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

  describe '#topic_due_date_span' do
    subject(:topic_due_date_span) { helper.topic_due_date_span(topic) }

    let(:topic) { FactoryBot.build(:topic) }

    context 'when topic does not have due date' do
      it { is_expected.to have_text('No due date') }
      it { is_expected.not_to match(/class/) }
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

        it { is_expected.to have_text('Due 1 day ago') }
        it { is_expected.to match(/class="theme-light"/) }
      end

      context 'when topic is not overdue' do
        before do
          travel_to(Time.utc(2019, 12, 31))
        end

        after do
          travel_back
        end

        it { is_expected.to have_text('Due in 1 day') }
        it { is_expected.not_to match(/class/) }
      end
    end

    context 'when topic has due date and is resolved' do
      before do
        topic.due_date = Time.utc(2020, 1, 1)
        topic.status = :resolved
      end

      it { is_expected.to have_text('Due Jan 1') }
      it { is_expected.not_to match(/class/) }
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

  describe '#vote_groups' do
    subject(:vote_groups) { helper.vote_groups(topic) }

    let(:topic) { FactoryBot.create(:topic) }
    let!(:upvote) { FactoryBot.create(:vote, emoji: 'thumbsup', votable: topic) }
    let!(:downvote) { FactoryBot.create(:vote, emoji: 'thumbsdown', votable: topic) }

    it { is_expected.to eq('thumbsup' => [upvote], 'thumbsdown' => [downvote]) }
  end

  describe '#votable_path' do
    subject(:votable_path) { helper.votable_path(votable) }

    context 'when votable is topic' do
      let(:votable) { FactoryBot.create(:topic) }

      it { is_expected.to eq([votable.team, votable]) }
    end

    context 'when votable is comment' do
      let(:votable) { FactoryBot.create(:comment) }

      it { is_expected.to eq([votable.topic.team, votable.topic, votable]) }
    end
  end
end
