# frozen_string_literal: true

class Comment < ApplicationRecord
  IMAGEDATA_REGEX = %r{\(data:image/\w+;base64,[^\s)]+\)}i

  validates :body, presence: { allow_blank: false }
  validates :body_html, presence: true
  validate :body_imagedata

  belongs_to :user
  belongs_to :topic

  has_many :notifications, as: :target, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  private

  def body_imagedata
    errors.add(:body, "can't contain base64 image data") if IMAGEDATA_REGEX.match?(body)
  end
end
