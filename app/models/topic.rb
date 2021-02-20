# frozen_string_literal: true

class Topic < ApplicationRecord
  validates :title, presence: { allow_blank: false }
  validates :description, presence: { allow_blank: false }
  validates :description_html, presence: true
  validates :outcome, presence: { allow_blank: false, allow_empty: false, allow_nil: true }
  validates :outcome_html, presence: { if: :outcome? }

  attr_accessor :description_checksum, :outcome_checksum

  validate :validate_description_checksum, if: proc { |topic| topic.description_checksum.present? }
  validate :validate_outcome_checksum, if: proc { |topic| topic.outcome_checksum.present? }

  belongs_to :user
  belongs_to :team

  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_users, through: :subscriptions, source: :user
  has_many :notifications, as: :target, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  enum status: { active: 0, closed: 1 }

  private

  def validate_description_checksum
    return if Digest::MD5.hexdigest(description_was.to_s) == description_checksum

    errors.add(:description, 'was changed')
  end

  def validate_outcome_checksum
    return if Digest::MD5.hexdigest(outcome_was.to_s) == outcome_checksum

    errors.add(:description, 'was changed')
  end
end
