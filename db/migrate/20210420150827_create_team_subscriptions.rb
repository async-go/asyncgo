# frozen_string_literal: true

class CreateTeamSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :team_subscriptions do |t|
      t.boolean :active, default: false, null: false

      t.references :team, foreign_key: true, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
