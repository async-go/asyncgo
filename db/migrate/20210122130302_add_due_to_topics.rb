# frozen_string_literal: true

class AddDueToTopics < ActiveRecord::Migration[6.1]
  def change
    add_column :topics, :due, :date
  end
end
