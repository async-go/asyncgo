# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :action, null: false
      t.date :read_at, null: true

      t.references :user, foreign_key: true, null: false
      t.references :actor, foreign_key: { to_table: :users }, null: false
      t.references :target, polymorphic: true, null: false

      t.timestamps
    end
  end
end
