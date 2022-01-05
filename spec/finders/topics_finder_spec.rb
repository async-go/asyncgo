# frozen_string_literal: true

RSpec.describe TopicsFinder, type: :finder do
  let(:team) { create(:team) }
  let(:finder) { described_class.new(team, [], {}) }

  describe '#call' do
    subject(:call) { finder.call }

    it 'includes specified relations' do
      raise 'not implemented: includes specified relations'
    end

    it 'filters topics by status' do
      raise 'not implemented: filters topics by status'
    end

    it 'orders topics by pinned' do
      raise 'not implemented: orders topics by pinned'
    end

    it 'orders topics by sort' do
      raise 'not implemented: orders topics by sort'
    end
  end
end
