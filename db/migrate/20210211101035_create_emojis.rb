# frozen_string_literal: true

class CreateEmojis < ActiveRecord::Migration[6.1]
  def change
    create_table :emojis do |t|
      t.string :name
      t.string :character
      t.references :vote, foreign_key: true
      t.timestamps
    end
  end
end
