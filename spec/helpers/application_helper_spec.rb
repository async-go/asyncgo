# frozen_string_literal: true

RSpec.describe ApplicationHelper, type: :helper do
  describe '#emoji_group_text' do
    subject(:emoji_group_text) { helper.emoji_group_text('cat', 2) }

    it { is_expected.to eq("#{Emoji.find_by_alias('cat').raw} 2") } # rubocop:disable Rails/DynamicFindBy
  end
end
