# frozen_string_literal: true

class Topic < ApplicationRecord
  validates :title, presence: { allow_blank: false }
  validates :description, presence: { allow_blank: false }
  validates :description_html, presence: true
  validates :outcome, presence: { allow_blank: false, allow_empty: false, allow_nil: true }
  validates :outcome_html, presence: { if: :outcome? }

  belongs_to :user
  belongs_to :team
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_users, through: :subscriptions, source: :user

  enum status: { active: 0, closed: 1 }
end
