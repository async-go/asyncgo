# frozen_string_literal: true

RSpec.describe TopicsController, type: :request do
  describe 'GET index' do
    subject(:get_index) { get '/topics' }

    it 'renders the new page' do
      get_index

      expect(response.body).to include('Topics')
    end
  end

  describe 'GET show' do
    subject(:get_show) { get "/topics/#{topic.id}" }

    let(:topic) { FactoryBot.create(:topic) }

    it 'renders the show page' do
      get_show

      expect(response.body).to include(topic.title)
    end
  end

  describe 'GET new' do
    subject(:get_new) { get '/topics/new' }

    it 'renders the show page' do
      get_new

      expect(response.body).to include('New Topic')
    end
  end

  describe 'POST create' do
    subject(:post_create) do
      post '/topics', params: { topic: { title: title } }
    end

    before do
      FactoryBot.create(:user)
    end

    context 'when topic is valid' do
      let(:title) { 'Topic title' }

      it 'creates the topic' do
        expect { post_create }.to change(Topic, :count).from(0).to(1)
      end

      it 'sets the flash' do
        post_create

        expect(controller.flash[:success]).to eq('Topic was successfully created.')
      end

      it 'redirects to topic' do
        post_create

        expect(response).to redirect_to(topic_path(Topic.last.id))
      end
    end

    context 'when topic is not valid' do
      let(:title) { '' }

      it 'does not create the topic' do
        expect { post_create }.not_to change(Topic, :count).from(0)
      end

      it 'shows the error' do
        post_create

        expect(response.body).to include('Title can&#39;t be blank')
      end
    end
  end
end
