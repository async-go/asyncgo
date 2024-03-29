# frozen_string_literal: true

class Comment < ApplicationRecord
  validates :body, presence: { allow_blank: false }, image_data: true
  validates :body_html, presence: true

  validates :is_archived, inclusion: [true, false]

  belongs_to :user
  belongs_to :topic

  has_many :notifications, as: :target, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
end
