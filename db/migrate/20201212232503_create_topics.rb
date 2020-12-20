# frozen_string_literal: true

class CreateTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :topics do |t|
      t.string :title, null: false
      t.references :user, null: false
      t.references :team, null: false

      t.timestamps
    end
  end
end
