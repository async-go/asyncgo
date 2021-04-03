# frozen_string_literal: true

class AddPinnedToTopics < ActiveRecord::Migration[6.1]
  def change
    add_column :topics, :pinned, :boolean, null: false, default: false
  end
end
