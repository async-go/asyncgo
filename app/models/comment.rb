# frozen_string_literal: true

class Comment < ApplicationRecord
  self.ignored_columns = %i[body body_html]

  validates :content, presence: { allow_blank: false }

  belongs_to :user
  belongs_to :topic

  has_many :notifications, as: :target, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  has_rich_text :content
end
