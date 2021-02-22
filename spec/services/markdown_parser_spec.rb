# frozen_string_literal: true

RSpec.describe MarkdownParser, type: :service do
  let(:user) { FactoryBot.create(:user, :team, :name) }
  let(:text) { "This is a __bold__ test for @#{user.email}" }

  describe '#call' do
    subject(:call) { described_class.new(user, text).call }

    it 'processes mentions' do
      expect(call).to include("<a href=\"mailto:#{user.email}\">#{user.name}</a>")
    end

    it 'processes markdowns' do
      expect(call).to include('<strong>bold</strong>')
    end
  end
end
