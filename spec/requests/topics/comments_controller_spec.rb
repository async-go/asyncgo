# frozen_string_literal: true

require './spec/support/sign_in_out_request_helpers'

RSpec.describe Topics::CommentsController, type: :request do
  include SignInOutRequestHelpers

  let(:topic) { FactoryBot.create(:topic) }

  describe 'GET new' do
    subject(:get_edit) { get "/topics/#{topic.id}/comments/new" }

    it 'renders the new page' do
      get_edit

      expect(response.body).to include('New Comment')
    end
  end

  describe 'POST create' do
    subject(:post_create) do
      post "/topics/#{topic.id}/comments", params: { topic_id: topic.id, comment: { body: body } }
    end

    before do
      sign_in(FactoryBot.create(:user))
    end

    context 'when comment is valid' do
      let(:body) { 'Comment body.' }

      it 'creates the comment' do
        expect { post_create }.to change(Comment, :count).from(0).to(1)
      end

      it 'sets the flash' do
        post_create

        expect(controller.flash[:success]).to eq('Comment was successfully created.')
      end

      it 'redirects to topic' do
        post_create

        expect(response).to redirect_to(topic_path(topic))
      end
    end

    context 'when comment is not valid' do
      let(:body) { '' }

      it 'does not create the comment' do
        expect { post_create }.not_to change(Comment, :count).from(0)
      end

      it 'shows the error' do
        post_create

        expect(response.body).to include('Body can&#39;t be blank')
      end
    end
  end
end
