# frozen_string_literal: true

class CreateTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :topics do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.string :decision, null: true
      t.references :user, null: false
      t.references :team, null: false

      t.timestamps
    end
  end
end
