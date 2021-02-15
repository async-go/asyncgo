# frozen_string_literal: true

require './spec/support/sign_in_out_request_helpers'
require './spec/support/unauthorized_user_examples'

RSpec.describe Teams::Topics::VotesController, type: :request do
  include SignInOutRequestHelpers

  let(:topic) { FactoryBot.create(:topic) }

  describe 'POST create' do
    subject(:post_create) do
      post "/teams/#{topic.team.id}/topics/#{topic.id}/votes", params: { vote: { emoji: emoji } }
    end

    context 'when user is authenticated' do
      let(:browsing_user) { FactoryBot.create(:user) }

      before do
        sign_in(browsing_user)
      end

      context 'when user is authorized' do
        before do
          topic.team.users << browsing_user
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

      context 'when user is not authorized' do
        let(:emoji) { 'cat' }

        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      let(:emoji) { 'cat' }

      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end

  describe 'DELETE destroy' do
    subject(:delete_destroy) { delete "/teams/#{topic.team.id}/topics/#{topic.id}/votes/#{vote.id}" }

    let(:vote) { FactoryBot.create(:vote, votable: topic) }

    context 'when user is authenticated' do
      let(:browsing_user) { FactoryBot.create(:user, team: topic.team) }

      before do
        sign_in(browsing_user)
      end

      context 'when user is authorized' do
        before do
          vote.update!(user: browsing_user)
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

      context 'when user is not authorized' do
        include_examples 'unauthorized user examples', 'You are not authorized.'
      end
    end

    context 'when user is not authenticated' do
      include_examples 'unauthorized user examples', 'You are not authorized.'
    end
  end
end
