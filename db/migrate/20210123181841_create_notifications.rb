# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false
      t.references :actor, null: false
      t.references :target, polymorphic: true, null: false

      t.integer :action, null: false
      t.date :read_at

      t.timestamps
    end
  end
end
