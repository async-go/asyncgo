# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::TopicsController, type: :request do
  describe 'GET index' do
    subject(:get_index) { get "/teams/#{team.id}/topics" }

    let(:team) { FactoryBot.create(:team) }

    context 'when user is authorized' do
      before do
        sign_in(FactoryBot.create(:user, team: team))
      end

      it 'renders the index page' do
        get_index

        expect(response.body).to include('Topics')
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'GET show' do
    subject(:get_show) { get "/teams/#{topic.team.id}/topics/#{topic.id}" }

    let(:topic) { FactoryBot.create(:topic) }

    context 'when user is authorized' do
      before do
        sign_in(FactoryBot.create(:user, team: topic.team))
      end

      it 'renders the show page' do
        get_show

        expect(response.body).to include(CGI.escapeHTML(topic.title))
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'GET new' do
    subject(:get_new) { get "/teams/#{team.id}/topics/new" }

    let(:team) { FactoryBot.create(:team) }

    context 'when user is authorized' do
      before do
        sign_in(FactoryBot.create(:user, team: team))
      end

      it 'renders the show page' do
        get_new

        expect(response.body).to include('Create Topic')
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'GET edit' do
    subject(:get_edit) { get "/teams/#{topic.team.id}/topics/#{topic.id}/edit" }

    let(:topic) { FactoryBot.create(:topic) }

    context 'when user is authorized' do
      before do
        sign_in(FactoryBot.create(:user, team: topic.team))
      end

      context 'when topic is active' do
        before do
          topic.update!(status: :active)
        end

        it 'renders the edit page' do
          get_edit

          expect(response.body).to include('Update Topic')
        end
      end

      context 'when topic is closed' do
        before do
          topic.update!(status: :closed)
        end

        it 'sets the alert flash' do
          get_edit
          follow_redirect!

          expect(controller.flash[:warning]).to eq('You are not authorized.')
        end

        it 'redirects the user back (to root)' do
          expect(get_edit).to redirect_to(root_path)
        end
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'POST create' do
    subject(:post_create) do
      post "/teams/#{team.id}/topics", params: { topic: { title: title, description: 'Test topic.' } }
    end

    let(:team) { FactoryBot.create(:team) }

    context 'when user is authorized' do
      let(:user) { FactoryBot.create(:user, team: team) }

      before do
        sign_in(user)
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

          expect(response).to redirect_to(team_topic_path(team, Topic.last.id))
        end

        it 'subscribes the user to the topic' do
          post_create

          expect(user.subscribed_topics).to contain_exactly(Topic.last)
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

        it 'does not subscribe user to the topic' do
          post_create

          expect(user.subscribed_topics).to be_empty
        end
      end
    end

    include_examples 'unauthorized user examples' do
      let(:title) { 'Sample title' }
    end
  end

  describe 'PATCH update' do
    subject(:patch_update) do
      patch "/teams/#{topic.team.id}/topics/#{topic.id}",
            params: { topic: params }
    end

    let(:topic) { FactoryBot.create(:topic) }

    context 'when user is authorized' do
      let(:user) { FactoryBot.create(:user, team: topic.team) }

      before do
        sign_in(user)
      end

      context 'when param is valid' do
        let(:params) do
          { outcome: 'This is a topic outcome.',
            outcome_checksum: Digest::MD5.hexdigest('') }
        end

        it 'updates the topic' do
          expect { patch_update }.to change { topic.reload.outcome }.from(nil).to('This is a topic outcome.')
        end

        it 'sets the flash' do
          patch_update

          expect(controller.flash[:success]).to eq('Topic was successfully updated.')
        end

        it 'redirects to topic' do
          patch_update

          expect(response).to redirect_to(team_topic_path(topic.team, Topic.last.id))
        end

        it 'does not subscribe user to the topic' do
          patch_update

          expect(user.subscribed_topics).to be_empty
        end
      end

      context 'when param checksum is invalid' do
        let(:params) do
          { outcome: 'valid', outcome_checksum: Digest::MD5.hexdigest('notvalid') }
        end

        it 'does not update the topic' do
          expect { patch_update }.not_to change { topic.reload.outcome }.from(nil)
        end

        it 'shows the error' do
          patch_update

          expect(response.body).to include(Topic::CHECKSUM_ERROR_MESSAGE)
        end

        it 'does not subscribe user to the topic' do
          patch_update

          expect(user.subscribed_topics).to be_empty
        end
      end

      context 'when param is not valid' do
        let(:params) do
          { outcome: '   ',
            outcome_checksum: Digest::MD5.hexdigest('') }
        end

        it 'does not update the topic' do
          expect { patch_update }.not_to change { topic.reload.outcome }.from(nil)
        end

        it 'shows the error' do
          patch_update

          expect(response.body).to include('Outcome can&#39;t be blank')
        end

        it 'does not subscribe user to the topic' do
          patch_update

          expect(user.subscribed_topics).to be_empty
        end
      end
    end

    include_examples 'unauthorized user examples' do
      let(:params) do
        { outcome: 'sample outcome',
          outcome_checksum: Digest::MD5.hexdigest('') }
      end
    end
  end

  describe 'PATCH toggle' do
    subject(:patch_toggle) do
      patch "/teams/#{topic.team.id}/topics/#{topic.id}/toggle",
            params: { topic: params }
    end

    let(:topic) { FactoryBot.create(:topic) }

    context 'when user is authorized' do
      let(:user) { FactoryBot.create(:user, team: topic.team) }

      before do
        sign_in(user)
      end

      context 'when topic is active' do
        let(:params) { { status: 'closed' } }

        before do
          topic.update!(status: 'active')
        end

        it 'closes the topic' do
          expect { patch_toggle }.to change { topic.reload.status }.from('active').to('closed')
        end

        it 'sets the flash' do
          patch_toggle

          expect(controller.flash[:success]).to eq('Topic status was successfully changed.')
        end

        it 'redirects to topic' do
          expect(patch_toggle).to redirect_to(team_topic_path(topic.team, topic))
        end
      end

      context 'when topic is closed' do
        let(:params) { { status: 'active' } }

        before do
          topic.update!(status: 'closed')
        end

        it 'opens the topic' do
          expect { patch_toggle }.to change { topic.reload.status }.from('closed').to('active')
        end

        it 'sets the flash' do
          patch_toggle

          expect(controller.flash[:success]).to eq('Topic status was successfully changed.')
        end

        it 'redirects to topic' do
          expect(patch_toggle).to redirect_to(team_topic_path(topic.team, topic))
        end
      end
    end

    include_examples 'unauthorized user examples' do
      let(:params) { { status: 'closed' } }
    end
  end

  describe 'POST subscribe' do
    subject(:post_subscribe) do
      post "/teams/#{topic.team.id}/topics/#{topic.id}/subscribe",
           params: { subscribed: subscribed }
    end

    let(:topic) { FactoryBot.create(:topic) }

    context 'when user is authorized' do
      let(:user) { FactoryBot.create(:user, team: topic.team) }

      before do
        sign_in(user)
      end

      context 'when user is subscribed' do
        let(:subscribed) { '0' }

        before do
          user.subscribed_topics << topic
        end

        it 'unsubscribes the user' do
          post_subscribe

          expect(user.subscribed_topics.reload).to be_empty
        end
      end

      context 'when user is not subscribed' do
        let(:subscribed) { '1' }

        it 'subscribes the user' do
          post_subscribe

          expect(user.subscribed_topics.reload).to contain_exactly(topic)
        end
      end
    end

    include_examples 'unauthorized user examples' do
      let(:subscribed) { '0' }
    end
  end
end
