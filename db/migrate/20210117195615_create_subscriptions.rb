# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.references :topic

      t.index %i[user_id topic_id], unique: true

      t.timestamps
    end
  end
end
