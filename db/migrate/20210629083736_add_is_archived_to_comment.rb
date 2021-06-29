# frozen_string_literal: true

class AddIsArchivedToComment < ActiveRecord::Migration[6.1]
  def change
    change_table :comments do |t|
      t.boolean :is_archived, default: false
    end
  end
end
