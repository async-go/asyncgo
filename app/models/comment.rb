# frozen_string_literal: true

class Comment < ApplicationRecord
  validates :body, presence: { allow_blank: false }
  has_rich_text :body

  belongs_to :user
  belongs_to :topic
end
