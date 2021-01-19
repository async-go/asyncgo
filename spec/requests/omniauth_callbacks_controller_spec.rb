# frozen_string_literal: true

RSpec.describe OmniauthCallbacksController, type: :request do
  describe 'POST google_oauth2' do
    subject(:post_google_oauth2) do
      post '/auth/google_oauth2'
      follow_redirect!
    end

    let(:auth_hash) do
      {
        provider: 'google_oauth2',
        info: {
          email: 'john@example.com'
        }
      }
    end

    before do
      OmniAuth.config.add_mock(:google_oauth2, auth_hash)
    end

    context 'when user does not exist' do
      it 'creates the user' do
        expect { post_google_oauth2 }.to change(User, :count).from(0).to(1)
      end

      it 'signs the user in' do
        post_google_oauth2

        expect(controller.send(:current_user)).not_to eq(nil)
      end

      it 'sets the flash' do
        post_google_oauth2

        expect(controller.flash[:success]).to eq('User was successfully authenticated.')
      end

      it 'redirects to redirect_uri' do
        expect(post_google_oauth2).to redirect_to(root_path)
      end
    end

    context 'when the user exists' do
      before do
        FactoryBot.create(:user, email: 'john@example.com')
      end

      it 'signs the user in' do
        post_google_oauth2

        expect(controller.send(:current_user)).not_to eq(nil)
      end

      it 'sets the flash' do
        post_google_oauth2

        expect(controller.flash[:success]).to eq('User was successfully authenticated.')
      end

      it 'redirects to redirect_uri' do
        expect(post_google_oauth2).to redirect_to(root_path)
      end
    end
  end
end

RSpec.describe OmniauthCallbacksController, type: :request do
  describe 'POST github' do
    subject(:post_github) do
      post '/auth/github'
      follow_redirect!
    end

    let(:auth_hash) do
      {
        provider: 'github',
        info: {
          email: 'john@example.com'
        }
      }
    end

    before do
      OmniAuth.config.add_mock(:github, auth_hash)
    end

    context 'when user does not exist' do
      it 'creates the user' do
        expect { post_github }.to change(User, :count).from(0).to(1)
      end

      it 'signs the user in' do
        post_github

        expect(controller.send(:current_user)).not_to eq(nil)
      end

      it 'sets the flash' do
        post_github

        expect(controller.flash[:success]).to eq('User was successfully authenticated.')
      end

      it 'redirects to redirect_uri' do
        expect(post_github).to redirect_to(root_path)
      end
    end

    context 'when the user exists' do
      before do
        FactoryBot.create(:user, email: 'john@example.com')
      end

      it 'signs the user in' do
        post_github

        expect(controller.send(:current_user)).not_to eq(nil)
      end

      it 'sets the flash' do
        post_github

        expect(controller.flash[:success]).to eq('User was successfully authenticated.')
      end

      it 'redirects to redirect_uri' do
        expect(post_github).to redirect_to(root_path)
      end
    end
  end
end