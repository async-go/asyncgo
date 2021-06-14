# frozen_string_literal: true

RSpec.describe TopicsFinder, type: :finder do
  let(:team) { FactoryBot.create(:team) }
  let(:finder) { described_class.new(team, [], {}) }

  describe '#call' do
    subject(:call) { finder.call }

    it 'includes specified relations' do
      fail
    end

    it 'filters topics by status' do
      fail
    end

    it 'orders topics by pinned' do
      fail
    end

    it 'orders topics by sort' do
    end
  end
end
