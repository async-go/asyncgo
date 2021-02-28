# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::Topics::Comments::VotesController, type: :request do
  let(:comment) { FactoryBot.create(:comment) }

  describe 'POST create' do
    subject(:post_create) do
      post "/teams/#{comment.topic.team.id}/topics/#{comment.topic.id}/comments/#{comment.id}/votes",
           params: { vote: { emoji: emoji } }
    end

    context 'when user is authorized' do
      before do
        sign_in(FactoryBot.create(:user, team: comment.topic.team))
      end

      context 'when vote is valid' do
        let(:emoji) { 'cat' }

        it 'creates the vote' do
          expect { post_create }.to change(Vote, :count).from(0).to(1)
        end

        it 'adds the vote' do
          post_create

          expect(Vote.last).to have_attributes(votable_id: comment.id, emoji: emoji)
        end

        it 'sets the flash' do
          post_create

          expect(controller.flash[:success]).to eq('Vote was successfully added.')
        end

        it 'redirects to comment page' do
          expect(post_create).to redirect_to(team_topic_comment_path(comment.topic.team, comment.topic, comment))
        end
      end

      context 'when vote is not valid' do
        let(:emoji) { 'notanemoji' }

        it 'does not create the vote' do
          expect { post_create }.not_to change(Vote, :count).from(0)
        end

        it 'sets the flash' do
          post_create

          expect(controller.flash[:danger]).to eq('There was an error while adding the vote.')
        end

        it 'redirects to comment page' do
          expect(post_create).to redirect_to(team_topic_comment_path(comment.topic.team, comment.topic, comment))
        end
      end
    end

    include_examples 'unauthorized user examples' do
      let(:emoji) { 'cat' }
    end
  end

  describe 'DELETE destroy' do
    subject(:delete_destroy) do
      delete "/teams/#{comment.topic.team.id}/topics/#{comment.topic.id}/comments/#{comment.id}/votes/#{vote.id}"
    end

    let(:vote) { FactoryBot.create(:vote, votable: comment) }

    context 'when user is authorized' do
      before do
        sign_in(vote.user)
      end

      it 'removes the vote' do
        expect { delete_destroy }.to change { Vote.find_by(id: vote.id) }.from(vote).to(nil)
      end

      it 'sets the flash' do
        delete_destroy

        expect(controller.flash[:success]).to eq('Vote was successfully removed.')
      end

      it 'redirects to comment page' do
        expect(delete_destroy).to redirect_to(team_topic_comment_path(comment.topic.team, comment.topic, comment))
      end
    end

    include_examples 'unauthorized user examples'
  end
end
