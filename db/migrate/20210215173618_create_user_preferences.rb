# frozen_string_literal: true

class CreateUserPreferences < ActiveRecord::Migration[6.1]
  def change
    create_table :user_preferences do |t|
      t.boolean :digest_enabled, default: true, null: false
      t.boolean :fluid_layout, default: false, null: false

      t.references :user, foreign_key: true, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
