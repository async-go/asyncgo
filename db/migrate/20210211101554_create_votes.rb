# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.references :emoji, foreign_key: true
      t.references :comment, foreign_key: true
      t.timestamps
    end
  end
end
