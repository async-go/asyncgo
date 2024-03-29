# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::Topics::CommentsController, type: :request do
  let(:topic) { create(:topic) }

  describe 'GET new' do
    subject(:get_new) { get "/teams/#{topic.team.id}/topics/#{topic.id}/comments/new" }

    context 'when user is authorized' do
      before do
        sign_in(topic.user)
      end

      it 'renders the edit page' do
        get_new

        expect(response.body).to include('Add Comment')
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'PUT archive' do
    subject(:put_archive) { put "/teams/#{topic.team.id}/topics/#{topic.id}/comments/#{comment.id}/archive" }

    let(:comment) { create(:comment, topic:) }

    context 'when user is authorized' do
      before do
        sign_in(comment.user)
      end

      it 'removes the comment' do
        expect { put_archive }.to change { Comment.find_by(id: comment.id).is_archived }.from(false).to(true)
      end

      it 'sets the flash' do
        put_archive

        expect(controller.flash[:success]).to eq('Comment was successfully archived.')
      end

      it 'redirects to topic page' do
        expect(put_archive).to redirect_to(team_topic_path(topic.team, topic))
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'GET edit' do
    subject(:get_edit) { get "/teams/#{topic.team.id}/topics/#{topic.id}/comments/#{comment.id}/edit" }

    let(:comment) { create(:comment, topic:) }

    context 'when user is authorized' do
      before do
        sign_in(comment.user)
      end

      it 'renders the edit page' do
        get_edit

        expect(response.body).to include('Update')
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'POST create' do
    subject(:post_create) do
      post "/teams/#{topic.team.id}/topics/#{topic.id}/comments", params: { comment: { body: } }
    end

    context 'when user is authorized' do
      let(:user) { create(:user, team: topic.team) }

      before do
        sign_in(user)
      end

      context 'when comment is valid' do
        let(:body) { 'Comment body.' }

        it 'creates the comment' do
          expect { post_create }.to change(Comment, :count).from(0).to(1)
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

        it 'does not subscribe user to the topic' do
          post_create

          expect(user.subscribed_topics).to be_empty
        end

        it 'renders the errors' do
          post_create

          expect(response.body).to include('Body can&#39;t be blank')
        end
      end
    end

    include_examples 'unauthorized user examples'
  end

  describe 'PATCH update' do
    subject(:patch_update) do
      patch "/teams/#{topic.team.id}/topics/#{topic.id}/comments/#{comment.id}", params: { comment: { body: } }
    end

    let(:comment) { create(:comment, topic:) }

    context 'when user is authorized' do
      before do
        sign_in(comment.user)
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

          expect(comment.user.subscribed_topics).to be_empty
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

          expect(comment.user.subscribed_topics).to be_empty
        end
      end
    end

    include_examples 'unauthorized user examples'
  end
end
