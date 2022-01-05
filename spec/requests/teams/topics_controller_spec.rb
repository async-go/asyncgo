# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::TopicsController, type: :request do
  describe 'GET index' do
    subject(:get_index) { get "/teams/#{team.id}/topics" }

    let(:team) { create(:team) }

    context 'when user is authorized' do
      before do
        sign_in(create(:user, team:))
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

    let(:topic) { create(:topic) }

    context 'when user is authorized' do
      let(:user) { create(:user, team: topic.team) }

      before do
        sign_in(user)
      end

      it 'renders the show page' do
        get_show

        expect(response.body).to include(CGI.escapeHTML(topic.title))
      end

      context 'when there are notifications' do
        before do
          comment = create(:comment, topic:)
          create(:notification, target: comment, user:)
          create(:notification, target: topic, user:)
        end

        it 'dismisses all topic notifications' do
          expect { get_show }.to change { user.notifications.where(read_at: nil).count }.from(2).to(0)
        end
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'GET archive' do
    subject(:get_archive) { get "/teams/#{topic.team.id}/topics/#{topic.id}/archive" }

    let(:topic) { create(:topic) }

    context 'when user is authorized' do
      before do
        sign_in(topic.user)
      end

      it 'removes the comment' do
        expect { get_archive }.to change { Topic.find_by(id: topic.id).is_archived }.from(false).to(true)
      end

      it 'sets the flash' do
        get_archive

        expect(controller.flash[:success]).to eq('Topic was successfully deleted.')
      end

      it 'redirects to root path' do
        expect(get_archive).to redirect_to(root_path)
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'GET new' do
    subject(:get_new) { get "/teams/#{team.id}/topics/new", params: }

    let(:team) { create(:team) }

    context 'when user is authorized' do
      before do
        sign_in(create(:user, team:))
      end

      context 'when no parameters are passed' do
        let(:params) { nil }

        it 'renders the new page' do
          get_new

          expect(response.body).to include('Create')
        end
      end

      context 'when extension parameters are passed' do
        let(:params) { { selection: 'Hello', context: 'https://www.google.com' } }

        it 'renders the new page' do
          get_new

          expect(response.body).to include('Create')
        end

        it 'includes the passed parameters' do
          get_new

          expect(response.body).to include('Created from: https://www.google.com', 'Hello')
        end
      end
    end

    include_examples 'unauthorized user examples' do
      let(:params) { nil }
    end
  end

  describe 'GET edit' do
    subject(:get_edit) { get "/teams/#{topic.team.id}/topics/#{topic.id}/edit" }

    let(:topic) { create(:topic) }

    context 'when user is authorized' do
      before do
        sign_in(create(:user, team: topic.team))
      end

      context 'when topic is active' do
        before do
          topic.update!(status: :active)
        end

        it 'renders the edit page' do
          get_edit

          expect(response.body).to include('Update')
        end
      end

      context 'when topic is resolved' do
        before do
          topic.update!(status: :resolved)
        end

        it 'renders the edit page' do
          get_edit

          expect(response.body).to include('Update')
        end
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'POST create' do
    subject(:post_create) do
      post "/teams/#{team.id}/topics", params: { topic: { title:, description: 'Test topic.' } }
    end

    let(:team) { create(:team) }

    context 'when user is authorized' do
      let(:user) { create(:user, team:) }

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

    let(:topic) { create(:topic) }

    context 'when user is authorized' do
      let(:user) { create(:user, team: topic.team) }

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

    let(:topic) { create(:topic) }

    context 'when user is authorized' do
      let(:user) { create(:user, team: topic.team) }

      before do
        sign_in(user)
      end

      context 'when topic is active' do
        let(:params) { { status: 'resolved' } }

        before do
          topic.update!(status: 'active')
        end

        it 'closes the topic' do
          expect { patch_toggle }.to change { topic.reload.status }.from('active').to('resolved')
        end

        it 'sets the flash' do
          patch_toggle

          expect(controller.flash[:success]).to eq('Topic status was successfully changed to resolved.')
        end

        it 'redirects to topic' do
          expect(patch_toggle).to redirect_to(team_topic_path(topic.team, topic))
        end
      end

      context 'when topic is resolved' do
        let(:params) { { status: 'active' } }

        before do
          topic.update!(status: 'resolved')
        end

        it 'opens the topic' do
          expect { patch_toggle }.to change { topic.reload.status }.from('resolved').to('active')
        end

        it 'sets the flash' do
          patch_toggle

          expect(controller.flash[:success]).to eq('Topic status was successfully changed to active.')
        end

        it 'redirects to topic' do
          expect(patch_toggle).to redirect_to(team_topic_path(topic.team, topic))
        end
      end
    end

    include_examples 'unauthorized user examples' do
      let(:params) { { status: 'resolved' } }
    end
  end

  describe 'POST subscribe' do
    subject(:post_subscribe) do
      post "/teams/#{topic.team.id}/topics/#{topic.id}/subscribe",
           params: { subscribed: }
    end

    let(:topic) { create(:topic) }

    context 'when user is authorized' do
      let(:user) { create(:user, team: topic.team) }

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

  describe 'PATCH pin' do
    subject(:patch_pin) do
      patch "/teams/#{topic.team.id}/topics/#{topic.id}/pin",
            params: { topic: params }
    end

    let(:topic) { create(:topic) }

    context 'when user is authorized' do
      let(:user) { create(:user, team: topic.team) }

      before do
        sign_in(user)
      end

      context 'when topic is pinned' do
        let(:params) { { pinned: '0' } }

        before do
          topic.update!(pinned: true)
        end

        it 'unpins the topic' do
          expect { patch_pin }.to change { topic.reload.pinned }.from(true).to(false)
        end

        it 'sets the flash' do
          patch_pin

          expect(controller.flash[:success]).to eq('Topic was successfully pinned / unpinned.')
        end

        it 'redirects to topic' do
          expect(patch_pin).to redirect_to(team_topic_path(topic.team, topic))
        end
      end

      context 'when topic is unpinned' do
        let(:params) { { pinned: '1' } }

        before do
          topic.update!(pinned: false)
        end

        it 'pins the topic' do
          expect { patch_pin }.to change { topic.reload.pinned }.from(false).to(true)
        end

        it 'sets the flash' do
          patch_pin

          expect(controller.flash[:success]).to eq('Topic was successfully pinned / unpinned.')
        end

        it 'redirects to topic' do
          expect(patch_pin).to redirect_to(team_topic_path(topic.team, topic))
        end
      end
    end

    include_examples 'unauthorized user examples' do
      let(:params) { { pinned: '0' } }
    end
  end
end
