# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :name, null: true

      t.references :team, foreign_key: true, null: true

      t.timestamps
    end
  end
end
