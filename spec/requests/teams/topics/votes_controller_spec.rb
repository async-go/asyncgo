# frozen_string_literal: true

require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::Topics::VotesController, type: :request do
  let(:topic) { FactoryBot.create(:topic) }

  describe 'POST create' do
    subject(:post_create) do
      post "/teams/#{topic.team.id}/topics/#{topic.id}/votes", params: { vote: { emoji: emoji } }
    end

    context 'when user is authorized' do
      before do
        sign_in(FactoryBot.create(:user, team: topic.team))
      end

      context 'when vote is valid' do
        let(:emoji) { 'cat' }

        it 'creates the vote' do
          expect { post_create }.to change(Vote, :count).from(0).to(1)
        end

        it 'adds the vote' do
          post_create

          expect(Vote.last).to have_attributes(votable_id: topic.id, emoji: emoji)
        end

        it 'sets the flash' do
          post_create

          expect(controller.flash[:success]).to eq('Vote was successfully added.')
        end

        it 'redirects to topic page' do
          expect(post_create).to redirect_to(team_topic_path(topic.team, topic))
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

        it 'redirects to topic page' do
          expect(post_create).to redirect_to(team_topic_path(topic.team, topic))
        end
      end
    end

    include_examples 'unauthorized user examples' do
      let(:emoji) { 'cat' }
    end
  end

  describe 'DELETE destroy' do
    subject(:delete_destroy) { delete "/teams/#{topic.team.id}/topics/#{topic.id}/votes/#{vote.id}" }

    let(:vote) { FactoryBot.create(:vote, votable: topic) }

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

      it 'redirects to topic page' do
        expect(delete_destroy).to redirect_to(team_topic_path(topic.team, topic))
      end
    end

    include_examples 'unauthorized user examples'
  end
end
