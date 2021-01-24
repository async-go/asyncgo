# frozen_string_literal: true

RSpec.describe TopicHelper, type: :helper do
  include ActiveSupport::Testing::TimeHelpers

  describe '#printable_due_date' do
    subject(:printable_due_date) { helper.printable_due_date(topic) }

    let(:topic) { FactoryBot.build(:topic) }

    context 'when topic does not have due date' do
      it { is_expected.to eq(nil) }
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

        it { is_expected.to eq('Due 1 day ago') }
      end

      context 'when topic is not overdue' do
        before do
          travel_to(Time.utc(2019, 12, 30))
        end

        after do
          travel_back
        end

        it { is_expected.to eq('Due in 2 days') }
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
end
