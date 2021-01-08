# frozen_string_literal: true

class CreateTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :topics do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :description_html, null: false
      t.text :decision, null: true
      t.text :decision_html, null: true
      t.references :user, null: false
      t.references :team, null: false

      t.timestamps
    end
  end
end
