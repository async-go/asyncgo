# frozen_string_literal: true

class MigrateCommentBody < ActiveRecord::Migration[6.1]
  class Comment < ActiveRecord::Base
    self.table_name = 'comments'

    # This is needed because ActionText uses a polymorphic association on the
    # Comment model. This means that without this trick the migration wouldn't
    # update the content for the Comment entries, but for
    # MigrateCommentBody::Comment entries instead.
    def self.name
      'Comment'
    end

    has_rich_text :content
  end

  def up
    Comment.reset_column_information
    Comment.find_each do |comment|
      comment.update!(content: comment.body_html)
    end
  end

  def down
    Comment.reset_column_information
    Comment.find_each do |comment|
      plain_content = comment.content.to_plain_text
      html_content = comment.content.body.to_html
      comment.update!(body: plain_content, body_html: html_content)
    end
  end
end
