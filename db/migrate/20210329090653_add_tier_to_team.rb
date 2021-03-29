class AddTierToTeam < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :tier, :integer, default: 0
  end
end
