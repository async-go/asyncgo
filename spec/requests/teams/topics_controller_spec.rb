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

        it 'renders the new page' do
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

          expect(response.body).to include(topic.title)
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

          expect(response.body).to include('New Topic')
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
      post "/teams/#{team.id}/topics",
           params: { topic: { title: title, description: 'Test topic.', user_id: user&.id } }
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
            params: { topic: { decision: decision } }
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

        context 'when decision is a sentence' do
          let(:decision) { 'This is a topic decision.' }

          it 'updates the topic' do
            expect { patch_update }.to change { topic.reload.decision }.from(nil).to(decision)
          end

          it 'sets the flash' do
            patch_update

            expect(controller.flash[:success]).to eq('Topic was successfully updated.')
          end

          it 'redirects to topic' do
            patch_update

            expect(response).to redirect_to(team_topic_path(topic.team, Topic.last.id))
          end
        end

        context 'when decision is empty' do
          let(:decision) { '' }

          before do
            topic.update!(decision: 'Sample decision')
          end

          it 'updates the topic' do
            expect { patch_update }.to change { topic.reload.decision }.to(nil)
          end

          it 'sets the flash' do
            patch_update

            expect(controller.flash[:success]).to eq('Topic was successfully updated.')
          end

          it 'redirects to topic' do
            patch_update

            expect(response).to redirect_to(team_topic_path(topic.team, Topic.last.id))
          end
        end

        context 'when decision is blank' do
          let(:decision) { '   ' }

          it 'does not update the topic' do
            expect { patch_update }.not_to change { topic.reload.decision }.from(nil)
          end

          it 'shows the error' do
            patch_update

            expect(response.body).to include('Decision can&#39;t be blank')
          end
        end
      end

      context 'when user is not authorized' do
        let(:decision) { nil }

        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      let(:user) { nil }
      let(:decision) { nil }

      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end
end
