# frozen_string_literal: true

class AddPinnedToTopic < ActiveRecord::Migration[6.1]
  def change
    add_column :topics, :pinned, :boolean, default: false
  end
end
