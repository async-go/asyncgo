# frozen_string_literal: true

require './spec/support/sign_in_out_request_helpers'
require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::TopicsController, type: :request do
  include SignInOutRequestHelpers

  describe 'GET index' do
    subject(:get_index) { get "/teams/#{team.id}/topics" }

    let(:team) { FactoryBot.create(:team) }

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in(user)
      end

      context 'when user is authorized' do
        before do
          team.users << user
        end

        it 'renders the index page' do
          get_index

          expect(response.body).to include('Topics')
        end
      end

      context 'when user is not authorized' do
        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end

  describe 'GET show' do
    subject(:get_show) { get "/teams/#{topic.team.id}/topics/#{topic.id}" }

    let(:topic) { FactoryBot.create(:topic) }

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in(user)
      end

      context 'when user is authorized' do
        before do
          topic.team.users << user
        end

        it 'renders the show page' do
          get_show

          expect(response.body).to include(CGI.escapeHTML(topic.title))
        end
      end

      context 'when user is not authenticated' do
        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end

  describe 'GET new' do
    subject(:get_new) { get "/teams/#{team.id}/topics/new" }

    let(:team) { FactoryBot.create(:team) }

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in(user)
      end

      context 'when user is authorized' do
        before do
          team.users << user
        end

        it 'renders the show page' do
          get_new

          expect(response.body).to include('Create Topic')
        end
      end

      context 'when user is not authorized' do
        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end

  describe 'GET edit' do
    subject(:get_edit) { get "/teams/#{team.id}/topics/#{topic.id}/edit" }

    let(:team) { FactoryBot.create(:team) }
    let(:topic) { FactoryBot.create(:topic, team: team) }

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in(user)
      end

      context 'when user is authorized' do
        before do
          team.users << user
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

          include_examples 'unauthorized user examples', 'You are not authorized.'
        end
      end

      context 'when user is not authorized' do
        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end

  describe 'POST create' do
    subject(:post_create) do
      post "/teams/#{team.id}/topics", params: { topic: { title: title, description: 'Test topic.' } }
    end

    let(:team) { FactoryBot.create(:team) }

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in(user)
      end

      context 'when user is authorized' do
        before do
          team.users << user
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

      context 'when user is not authorized' do
        let(:title) { nil }

        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      let(:title) { nil }
      let(:user) { nil }

      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end

  describe 'PATCH update' do
    subject(:patch_update) do
      patch "/teams/#{topic.team.id}/topics/#{topic.id}",
            params: { topic: { outcome: outcome } }
    end

    let(:topic) { FactoryBot.create(:topic) }

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in(user)
      end

      context 'when user is authorized' do
        before do
          topic.team.users << user
        end

        context 'when topic is valid' do
          let(:outcome) { 'This is a topic outcome.' }

          it 'updates the topic' do
            expect { patch_update }.to change { topic.reload.outcome }.from(nil).to(outcome)
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

        context 'when topic is not valid' do
          let(:outcome) { '   ' }

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

      context 'when user is not authorized' do
        let(:outcome) { nil }

        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      let(:user) { nil }
      let(:outcome) { nil }

      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe 'POST subscribe' do
    subject(:post_subscribe) do
      post "/teams/#{topic.team.id}/topics/#{topic.id}/subscribe",
           params: { subscribed: subscribed }
    end

    let(:topic) { FactoryBot.create(:topic) }

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in(user)
      end

      context 'when user is authorized' do
        before do
          topic.team.users << user
        end

        context 'when user is subscribed' do
          before do
            user.subscribed_topics << topic
          end

          context 'when subscription is checked' do
            let(:subscribed) { '1' }

            it 'does not unsubscribe the user' do
              post_subscribe

              expect(user.subscribed_topics.reload).to contain_exactly(topic)
            end
          end

          context 'when subscription is not checked' do
            let(:subscribed) { '0' }

            it 'unsubscribes the user' do
              post_subscribe

              expect(user.subscribed_topics.reload).to be_empty
            end
          end
        end

        context 'when user is not subscribed' do
          context 'when subscription is checked' do
            let(:subscribed) { '1' }

            it 'subscribes the user' do
              post_subscribe

              expect(user.subscribed_topics.reload).to contain_exactly(topic)
            end
          end

          context 'when subscription is not checked' do
            let(:subscribed) { '0' }

            it 'does not subscribe the user' do
              post_subscribe

              expect(user.subscribed_topics.reload).to be_empty
            end
          end
        end
      end

      context 'when user is not authorized' do
        let(:subscribed) { nil }

        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      let(:subscribed) { nil }

      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
