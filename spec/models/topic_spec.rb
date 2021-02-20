# frozen_string_literal: true

RSpec.describe Topic, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:description_html) }

    describe '#validate_description_checksum' do
      subject(:valid?) { topic.valid? }

      let(:topic) { FactoryBot.create(:topic, description: 'old') }

      before do
        topic.description = 'new'
      end

      context 'when description checksum is not set' do
        before do
          topic.description_checksum = nil
        end

        it { is_expected.to eq(false) }
      end

      context 'when description checksum is valid' do
        before do
          topic.description_checksum = Digest::MD5.hexdigest('old')
        end

        it { is_expected.to eq(true) }
      end

      context 'when description checksum is not valid' do
        before do
          topic.description_checksum = Digest::MD5.hexdigest('notvalid')
        end

        it { is_expected.to eq(false) }
      end
    end

    describe '#validate_outcome_checksum' do
      subject(:valid?) { topic.valid? }

      let(:topic) { FactoryBot.create(:topic, outcome: 'old') }

      before do
        topic.outcome = 'new'
      end

      context 'when description checksum is not set' do
        before do
          topic.outcome_checksum = nil
        end

        it { is_expected.to eq(false) }
      end

      context 'when description checksum is valid' do
        before do
          topic.outcome_checksum = Digest::MD5.hexdigest('old')
        end

        it { is_expected.to eq(true) }
      end

      context 'when description checksum is not valid' do
        before do
          topic.outcome_checksum = Digest::MD5.hexdigest('notvalid')
        end

        it { is_expected.to eq(false) }
      end
    end
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:team) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
    it { is_expected.to have_many(:subscribed_users) }
    it { is_expected.to have_many(:notifications) }
    it { is_expected.to have_many(:votes) }
  end

  it { is_expected.to define_enum_for(:status).with_values(%i[active closed]) }
end
