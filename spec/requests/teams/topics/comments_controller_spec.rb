# frozen_string_literal: true

require './spec/support/sign_in_out_request_helpers'
require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::Topics::CommentsController, type: :request do
  include SignInOutRequestHelpers

  let(:topic) { FactoryBot.create(:topic) }

  describe 'GET new' do
    subject(:get_new) { get "/teams/#{topic.team.id}/topics/#{topic.id}/comments/new" }

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in(user)
      end

      context 'when user is authorized' do
        before do
          topic.team.users << user
        end

        it 'renders the new page' do
          get_new

          expect(response.body).to include('New Comment')
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
    subject(:get_edit) { get "/teams/#{topic.team.id}/topics/#{topic.id}/comments/#{comment.id}/edit" }

    let(:comment) { FactoryBot.create(:comment, topic: topic) }

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in(user)
        topic.team.users << user
      end

      context 'when user is authorized' do
        before do
          comment.update!(user: user)
        end

        it 'renders the new page' do
          get_edit

          expect(response.body).to include('Edit Comment')
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
      post "/teams/#{topic.team.id}/topics/#{topic.id}/comments", params: { comment: { body: body, user_id: user&.id } }
    end

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in(user)
      end

      context 'when user is authorized' do
        before do
          topic.team.users << user
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

            expect(response).to redirect_to(team_topic_path(topic.team, topic))
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

      context 'when user is not authorized' do
        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      let(:user) { nil }

      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end

  describe 'PATCH update' do
    subject(:patch_update) do
      patch "/teams/#{topic.team.id}/topics/#{topic.id}/comments/#{comment.id}", params: { comment: { body: body } }
    end

    let(:comment) { FactoryBot.create(:comment, topic: topic) }

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in(user)
        topic.team.users << user
      end

      context 'when user is authorized' do
        before do
          comment.update!(user: user)
        end

        context 'when comment is valid' do
          let(:body) { 'Updated body.' }

          it 'updates the comment' do
            expect { patch_update }.to change { comment.reload.body }.to('Updated body.')
          end

          it 'sets the flash' do
            patch_update

            expect(controller.flash[:success]).to eq('Comment was successfully updated.')
          end

          it 'redirects to topic' do
            patch_update

            expect(response).to redirect_to(team_topic_path(topic.team, topic))
          end
        end

        context 'when comment is not valid' do
          let(:body) { '' }

          it 'does not update the comment' do
            expect { patch_update }.not_to(change { comment.reload.body })
          end

          it 'shows the error' do
            patch_update

            expect(response.body).to include('Body can&#39;t be blank')
          end
        end
      end

      context 'when user is not authorized' do
        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      let(:user) { nil }

      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end
end
