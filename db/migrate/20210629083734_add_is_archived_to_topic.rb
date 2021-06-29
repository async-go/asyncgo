# frozen_string_literal: true

class AddIsArchivedToTopic < ActiveRecord::Migration[6.1]
  def change
    change_table :topics do |t|
      t.boolean :is_archived, default: false
    end
  end
end
