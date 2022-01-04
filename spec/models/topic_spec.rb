# frozen_string_literal: true

RSpec.describe Topic, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:description_html) }

    describe '#validate_description_checksum' do
      subject(:valid?) { topic.valid? }

      let(:topic) { create(:topic, description: 'old') }

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

      let(:topic) { create(:topic, outcome: 'old') }

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

    describe 'description image data' do
      subject(:valid?) { topic.valid? }

      let(:topic) { build(:topic, description:) }

      context 'when description does not have image data' do
        let(:description) { 'hello world' }

        it { is_expected.to eq(true) }
      end

      context 'when description has image data' do
        let(:description) { '![image.png](data:image/png;base64,abcdefg)' }

        it { is_expected.to eq(false) }

        it 'adds an image data error to description' do
          topic.valid?

          expect(topic.errors.first).to have_attributes(attribute: :description)
        end
      end
    end

    describe 'outcome image data' do
      subject(:valid?) { topic.valid? }

      let(:topic) { build(:topic, outcome:) }

      context 'when outcome does not have image data' do
        let(:outcome) { 'hello world' }

        it { is_expected.to eq(true) }
      end

      context 'when outcome has image data' do
        let(:outcome) { '![image.png](data:image/png;base64,abcdefg)' }

        it { is_expected.to eq(false) }

        it 'adds an image data error to outcome' do
          topic.valid?

          expect(topic.errors.first).to have_attributes(attribute: :outcome)
        end
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

  it { is_expected.to define_enum_for(:status).with_values(%i[active resolved]) }

  describe '#last_interacted' do
    subject(:last_interacted) { topic.last_interacted }

    let(:topic) { create(:topic) }

    context 'when topic has no comments' do
      it { is_expected.to eq(topic.updated_at) }
    end

    context 'when topic has comments' do
      let(:comments) { create_list(:comment, 2, topic:) }

      context 'when topic was updated after last comment' do
        before do
          topic.update!(updated_at: comments.second.updated_at.tomorrow)
        end

        it { is_expected.to eq(topic.updated_at) }
      end

      context 'when topic was updated before last comment' do
        before do
          comments.last.update!(updated_at: topic.updated_at.tomorrow)
        end

        it { is_expected.to eq(comments.last.updated_at) }
      end
    end
  end
end
