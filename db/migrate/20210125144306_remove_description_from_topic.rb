# frozen_string_literal: true

class RemoveDescriptionFromTopic < ActiveRecord::Migration[6.1]
  def change
    remove_column :topics, :description, :text
    remove_column :topics, :description_html, :text
  end
end
