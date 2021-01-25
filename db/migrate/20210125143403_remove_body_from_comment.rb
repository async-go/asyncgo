# frozen_string_literal: true

class RemoveBodyFromComment < ActiveRecord::Migration[6.1]
  def change
    remove_column :comments, :body, :text
    remove_column :comments, :body_html, :text
  end
end
