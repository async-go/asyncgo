# frozen_string_literal: true

class AddStatusToTopics < ActiveRecord::Migration[6.1]
  TOPIC_ACTIVE_STATUS = 0

  def change
    add_column :topics, :status, :integer, null: false, default: TOPIC_ACTIVE_STATUS
  end
end
