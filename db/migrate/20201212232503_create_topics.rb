# frozen_string_literal: true

class CreateTopics < ActiveRecord::Migration[6.1]
  TOPIC_ACTIVE_STATUS = 0

  def change
    create_table :topics do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :description_html, null: false
      t.text :outcome, null: true
      t.text :outcome_html, null: true
      t.date :due_date, null: true
      t.integer :status, null: false, default: TOPIC_ACTIVE_STATUS

      t.references :user, foreign_key: true, null: false
      t.references :team, foreign_key: true, null: false

      t.timestamps
    end
  end
end
