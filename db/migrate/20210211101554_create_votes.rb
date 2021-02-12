# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.string :emoji, null: false

      t.references :user, foreign_key: true, null: false
      t.references :votable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
