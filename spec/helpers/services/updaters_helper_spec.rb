# frozen_string_literal: true

RSpec.describe Services::UpdatersHelper, type: :helper do
  describe 'remove_imagedata' do

    context 'when image data is present' do
      subject(:remove_imagedata) { helper.remove_imagedata('(data:image/png;base64,iVBORw0K)') }

      it { is_expected.to eq('()') }
    end
  end
end
