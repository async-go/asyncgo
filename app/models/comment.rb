# frozen_string_literal: true

class Comment < ApplicationRecord
  validates :body, presence: { allow_blank: false }
  validates :body_html, presence: true

  belongs_to :user
  belongs_to :topic

  has_many :notifications, as: :target, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  after_create_commit -> { broadcast_append_later_to topic, partial: 'teams/topics/comments/comment' }
  after_update_commit -> { broadcast_replace_later_to topic, partial: 'teams/topics/comments/comment' }
end
