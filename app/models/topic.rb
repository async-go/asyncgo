# frozen_string_literal: true

class Topic < ApplicationRecord
  validates :title, presence: { allow_blank: false }
  validates :description, presence: { allow_blank: false }
  validates :description_html, presence: true
  validates :outcome, presence: { allow_blank: false, allow_empty: false, allow_nil: true }
  validates :outcome_html, presence: { if: :outcome? }
  validates :due, presence: { allow_nil: true }

  belongs_to :user
  belongs_to :team
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_users, through: :subscriptions, source: :user

  enum status: { active: 0, closed: 1 }

  def days_remaining
    ((Time.now.utc.to_date - due.to_date) * -1).to_i if due.present?
  end
end
