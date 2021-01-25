# frozen_string_literal: true

class RemoveOutcomeFromTopic < ActiveRecord::Migration[6.1]
  def change
    remove_column :topics, :outcome, :text
    remove_column :topics, :outcome_html, :text
  end
end
