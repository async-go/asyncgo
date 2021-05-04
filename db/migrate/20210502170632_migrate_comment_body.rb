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
      comment.update!(content: comment.body)
    end
  end

  def down
    Comment.reset_column_information
    Comment.find_each do |comment|
      content = comment.content.to_plain_text
      comment.update!(body: content, body_html: "<p>#{content}</p>")
    end
  end
end
