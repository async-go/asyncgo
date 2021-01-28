# frozen_string_literal: true

RSpec.describe TeamsHelper, type: :helper do
  describe '#users_in_team' do
    subject(:users_in_team) { helper.users_in_team(team) }

    let(:team) { FactoryBot.create(:team) }
    let(:user_in_team) { FactoryBot.create(:user, team: team) }
    let(:current_user) { FactoryBot.create(:user, team: team) }

    before do
      without_partial_double_verification do
        allow(helper).to receive(:current_user).and_return(current_user)
      end

      FactoryBot.create(:user)
    end

    it 'returns users in team except current user' do
      expect(users_in_team).to contain_exactly(user_in_team)
    end
  end
end
