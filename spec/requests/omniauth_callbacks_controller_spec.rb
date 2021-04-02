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
          email: 'john@example.com',
          name: 'John Sample'
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

      it 'updates the users name' do
        post_google_oauth2

        expect(User.last.name).to eq('John Sample')
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
      let!(:user) { FactoryBot.create(:user, email: 'john@example.com') }

      it 'signs the user in' do
        post_google_oauth2

        expect(controller.send(:current_user)).to eq(user)
      end

      it 'updates the users name' do
        expect { post_google_oauth2 }.to change { user.reload.name }.from(nil).to('John Sample')
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

  describe 'POST github' do
    subject(:post_github) do
      post '/auth/github'
      follow_redirect!
    end

    let(:auth_hash) do
      {
        provider: 'github',
        info: {
          email: 'john@example.com',
          name: 'John Sample'

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

      it 'updates the users name' do
        post_github

        expect(User.last.name).to eq('John Sample')
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
      let!(:user) { FactoryBot.create(:user, email: 'john@example.com') }

      it 'signs the user in' do
        post_github

        expect(controller.send(:current_user)).not_to eq(nil)
      end

      it 'updates the users name' do
        expect { post_github }.to change { user.reload.name }.from(nil).to('John Sample')
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

  describe 'POST slack' do
    subject(:post_slack) do
      post '/auth/slack'
      follow_redirect!
    end

    let(:slack_omniauth_strategy) do
      { authed_user: { token: 'test' } }
    end

    before do
      strategy_double = instance_double(
        OmniAuth::Slack::OAuth2::AccessToken,
        authed_user: OpenStruct.new({ token: 'test' })
      )
      allow_any_instance_of(OmniAuth::Strategies::Slack).to receive(:access_token).and_return(strategy_double) # rubocop:disable RSpec/AnyInstance

      access_token_double = instance_double(
        OmniAuth::Slack::OAuth2::AccessToken, get: instance_double(
          OAuth2::Response, parsed: { 'user' => { 'email' => 'john@example.com', 'name' => 'John Sample' } }
        )
      )
      allow(OmniAuth::Slack).to receive(:build_access_token).and_return(access_token_double)
    end

    context 'when user does not exist' do
      it 'creates the user' do
        expect { post_slack }.to change(User, :count).from(0).to(1)
      end

      it 'signs the user in' do
        post_slack

        expect(controller.send(:current_user)).not_to eq(nil)
      end

      it 'updates the users name' do
        post_slack

        expect(User.last.name).to eq('John Sample')
      end

      it 'sets the flash' do
        post_slack

        expect(controller.flash[:success]).to eq('User was successfully authenticated.')
      end

      it 'redirects to redirect_uri' do
        expect(post_slack).to redirect_to(root_path)
      end
    end

    context 'when the user exists' do
      let!(:user) { FactoryBot.create(:user, email: 'john@example.com') }

      it 'signs the user in' do
        post_slack

        expect(controller.send(:current_user)).to eq(user)
      end

      it 'updates the users name' do
        expect { post_slack }.to change { user.reload.name }.from(nil).to('John Sample')
      end

      it 'sets the flash' do
        post_slack

        expect(controller.flash[:success]).to eq('User was successfully authenticated.')
      end

      it 'redirects to redirect_uri' do
        expect(post_slack).to redirect_to(root_path)
      end
    end
  end
end
