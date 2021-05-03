# frozen_string_literal: true

class DeprecateCommentBody < ActiveRecord::Migration[6.1]
  def change
    change_column_null :comments, :body, true
    change_column_null :comments, :body_html, true
  end
end
