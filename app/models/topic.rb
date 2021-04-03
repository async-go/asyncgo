# frozen_string_literal: true

class Topic < ApplicationRecord
  CHECKSUM_ERROR_MESSAGE = <<-ERROR_TEXT.squish.freeze
    was changed by somebody else and you can no longer save. Open this same
    topic in a new tab and merge your changes manually (do not refresh or
    navigate away from this page or your changes will be lost.)
  ERROR_TEXT

  validates :title, presence: { allow_blank: false }
  validates :description, presence: { allow_blank: false }
  validates :description_html, presence: true
  validates :outcome, presence: { allow_blank: false, allow_empty: false, allow_nil: true }
  validates :outcome_html, presence: { if: :outcome? }

  attr_accessor :description_checksum, :outcome_checksum

  validate :validate_description_checksum, on: :update, if: :description_changed?
  validate :validate_outcome_checksum, on: :update, if: :outcome_changed?

  belongs_to :user
  belongs_to :team

  has_many :comments, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_users, through: :subscriptions, source: :user

  has_many :notifications, as: :target, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  enum status: { active: 0, closed: 1 }

  acts_as_taggable_on :labels

  private

  def validate_description_checksum
    return if Digest::MD5.hexdigest(description_was.to_s) == description_checksum

    errors.add(:description, CHECKSUM_ERROR_MESSAGE)
  end

  def validate_outcome_checksum
    return if Digest::MD5.hexdigest(outcome_was.to_s) == outcome_checksum

    errors.add(:outcome, CHECKSUM_ERROR_MESSAGE)
  end
end
