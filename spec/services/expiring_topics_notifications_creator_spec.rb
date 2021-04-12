# frozen_string_literal: true

RSpec.describe ExpiringTopicsNotificationsCreator, type: :service do
  let(:team) { FactoryBot.create(:team) }
  let(:user) { FactoryBot.create(:user, team: team) }

  let!(:expiring_topic) do
    FactoryBot.create(:topic, due_date: Time.zone.tomorrow, team: team, subscribed_users: [user])
  end

  before do
    FactoryBot.create(:topic, team: team, subscribed_users: [user])
    FactoryBot.create(:topic, due_date: 2.days.from_now, team: team, subscribed_users: [user])
  end

  describe '#call' do
    subject(:call) { described_class.new.call }

    it 'creates only notifications for expiring topics' do
      call

      expect(user.notifications.reload).to contain_exactly(
        having_attributes(action: 'expiring', user: user, target: expiring_topic, actor: expiring_topic.user)
      )
    end
  end
end
