# frozen_string_literal: true

RSpec.describe Comment, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:body_html) }

    describe 'body image data' do
      subject(:valid?) { comment.valid? }

      let(:comment) { build(:comment, body:) }

      context 'when body does not have image data' do
        let(:body) { 'hello world' }

        it { is_expected.to eq(true) }
      end

      context 'when body has image data' do
        let(:body) { '![image.png](data:image/png;base64,abcdefg)' }

        it { is_expected.to eq(false) }

        it 'adds an image data error to body' do
          comment.valid?

          expect(comment.errors.first).to have_attributes(attribute: :body)
        end
      end
    end
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:topic) }
    it { is_expected.to have_many(:notifications) }
    it { is_expected.to have_many(:votes) }
  end
end
