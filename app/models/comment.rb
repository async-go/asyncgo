# frozen_string_literal: true

class Comment < ApplicationRecord
  validates :body, presence: { allow_blank: false }
  validates :body_html, presence: { allow_blank: false }

  belongs_to :user
  belongs_to :topic

  has_many :notifications, as: :target, dependent: :destroy
  has_many :votes, dependent: :destroy
end
