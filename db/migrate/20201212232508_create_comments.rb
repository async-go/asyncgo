# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.text :body_html, null: false
      t.references :topic, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
