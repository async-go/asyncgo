# frozen_string_literal: true

RSpec.describe Comment, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:body_html) }

    describe '#body_imagedata' do
      subject(:valid?) { comment.valid? }

      let(:comment) { FactoryBot.build(:comment) }

      context 'when body does not have image data' do
        before do
          comment.body = 'hello world'
        end

        it { is_expected.to eq(true) }
      end

      context 'when body has image data' do
        before do
          comment.body = '![image.png](data:image/png;base64,abcdefg)'
        end

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
