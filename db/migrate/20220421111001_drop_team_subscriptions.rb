# frozen_string_literal: true

class DropTeamSubscriptions < ActiveRecord::Migration[7.0]
  def change
    drop_table :team_subscriptions do |t|
      t.boolean :active, default: false, null: false

      t.references :team, foreign_key: true, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
