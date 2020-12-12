# frozen_string_literal: true

RSpec.describe HomeController, type: :request do
  describe 'GET index' do
    subject(:get_index) { get '/' }

    it 'renders the home page' do
      get_index

      expect(response.body).to include('Hello, world!')
    end
  end
end
