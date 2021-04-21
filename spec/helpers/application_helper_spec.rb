# frozen_string_literal: true

RSpec.describe ApplicationHelper, type: :helper do
  describe '#emoji_group_text' do
    subject(:emoji_group_text) { helper.emoji_group_text('cat', 2) }

    it { is_expected.to eq("#{Emoji.find_by_alias('cat').raw} 2") } # rubocop:disable Rails/DynamicFindBy
  end

  describe 'new_updates_button' do
    subject(:new_updates_button) { helper.new_updates_button('https://google.com', date) }

    context 'when 7 days have not passed since date' do
      let(:date) { Time.zone.today - 6 }

      it { is_expected.to include('btn-outline-success', 'https://google.com') }
    end

    context 'when 7 days have passed since date' do
      let(:date) { Time.zone.today - 8 }

      it { is_expected.to include('btn-outline-secondary', 'https://google.com') }
    end
  end
end
