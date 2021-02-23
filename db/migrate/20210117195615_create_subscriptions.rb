# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true, null: false
      t.references :topic, foreign_key: true, null: false

      t.index %i[user_id topic_id], unique: true

      t.timestamps
    end
  end
end
