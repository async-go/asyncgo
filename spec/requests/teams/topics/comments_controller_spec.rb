# frozen_string_literal: true

require './spec/support/sign_in_out_request_helpers'
require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::Topics::CommentsController, type: :request do
  include SignInOutRequestHelpers

  let(:topic) { FactoryBot.create(:topic) }

  describe 'GET edit' do
    subject(:get_edit) { get "/teams/#{topic.team.id}/topics/#{topic.id}/comments/#{comment.id}/edit" }

    let(:comment) { FactoryBot.create(:comment, topic: topic) }

    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user, team: topic.team) }

      before do
        sign_in(user)
      end

      context 'when user is authorized' do
        before do
          comment.update!(user: user)
        end

        it 'renders the edit page' do
          get_edit

          expect(response.body).to include('Update Comment')
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
      post "/teams/#{topic.team.id}/topics/#{topic.id}/comments", params: { comment: { body: body } }
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

          it 'subscribes the user to the topic' do
            post_create

            expect(user.subscribed_topics).to contain_exactly(topic)
          end
        end

        context 'when comment is not valid' do
          let(:body) { '' }

          it 'does not create the comment' do
            expect { post_create }.not_to change(Comment, :count).from(0)
          end

          it 'sets the flash' do
            post_create

            expect(controller.flash[:danger]).to eq("Body can't be blank, Body html can't be blank")
          end

          it 'redirects to topic' do
            post_create

            expect(response).to redirect_to(team_topic_path(topic.team, topic))
          end

          it 'does not subscribe user to the topic' do
            post_create

            expect(user.subscribed_topics).to be_empty
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
      let(:user) { FactoryBot.create(:user, team: topic.team) }

      before do
        sign_in(user)
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

          it 'does not subscribe user to the topic' do
            patch_update

            expect(user.subscribed_topics).to be_empty
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

          it 'does not subscribe user to the topic' do
            patch_update

            expect(user.subscribed_topics).to be_empty
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
