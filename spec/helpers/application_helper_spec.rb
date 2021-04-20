# frozen_string_literal: true

RSpec.describe ApplicationHelper, type: :helper do
  describe '#emoji_group_text' do
    subject(:emoji_group_text) { helper.emoji_group_text('cat', 2) }

    it { is_expected.to eq("#{Emoji.find_by_alias('cat').raw} 2") } # rubocop:disable Rails/DynamicFindBy
  end

  describe 'whatsnew_button (within 7 days ago)' do
    subject(:whatsnew_button_past) { helper.whatsnew_button('https://google.com', Time.zone.today - 6) }

    it { is_expected.to include('btn-outline-success', 'https://google.com') }
  end

  describe 'whatsnew_button (beyond 7 days ago)' do
    subject(:whatsnew_button_future) { helper.whatsnew_button('https://google.com', Time.zone.today - 7) }

    it { is_expected.to include('btn-outline-secondary', 'https://google.com') }
  end

end
