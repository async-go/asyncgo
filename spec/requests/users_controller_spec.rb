# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe UsersController, type: :request do
  describe 'GET edit' do
    subject(:get_edit) { get "/users/#{user.id}/edit" }

    let(:user) { create(:user) }

    context 'when user is authorized' do
      before do
        sign_in(user)
      end

      it 'renders the edit page' do
        get_edit

        expect(response.body).to include(CGI.escapeHTML(user.printable_name))
      end
    end

    include_examples 'unauthorized user examples'
  end
end
